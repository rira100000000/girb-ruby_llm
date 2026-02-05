# frozen_string_literal: true

require "ruby_llm"
require "girb/providers/base"

module Girb
  module Providers
    class RubyLlm < Base
      def initialize(model: nil)
        @model = model
      end

      def chat(messages:, system_prompt:, tools:, binding: nil)
        # Use specified model or RubyLLM's default
        chat_options = @model ? { model: @model } : {}
        ruby_llm_chat = ::RubyLLM.chat(**chat_options)

        # Set system prompt
        ruby_llm_chat.with_instructions(system_prompt) if system_prompt && !system_prompt.empty?

        # Add tool schemas (for API payload generation only, not auto-executed)
        tool_instances = build_tools(tools)
        tool_instances.each { |tool| ruby_llm_chat.with_tool(tool) }

        # Add all messages to the chat
        add_messages_to_chat(ruby_llm_chat, messages)

        # Get raw response without auto-executing tools
        response = raw_complete(ruby_llm_chat)

        parse_response(response)
      rescue Faraday::BadRequestError => e
        Response.new(error: "API Error: #{e.message}")
      rescue StandardError => e
        Response.new(error: "Error: #{e.message}")
      end

      private

      # Call provider.complete() directly, bypassing RubyLLM's handle_tool_calls.
      # This returns the raw response so the caller can handle tool execution.
      def raw_complete(chat)
        provider = chat.instance_variable_get(:@provider)
        provider.complete(
          chat.messages,
          tools: chat.tools,
          temperature: chat.instance_variable_get(:@temperature),
          model: chat.model,
          params: chat.params,
          headers: chat.headers,
          schema: chat.schema,
          thinking: chat.instance_variable_get(:@thinking)
        )
      end

      def add_messages_to_chat(chat, messages)
        messages.each do |msg|
          case msg[:role]
          when :user
            chat.add_message(role: :user, content: msg[:content])
          when :assistant
            chat.add_message(role: :assistant, content: msg[:content])
          when :tool_call
            id = msg[:id] || "call_#{SecureRandom.hex(12)}"
            chat.add_message(
              role: :assistant,
              content: nil,
              tool_calls: {
                id => ::RubyLLM::ToolCall.new(
                  id: id,
                  name: msg[:name],
                  arguments: msg[:args]
                )
              }
            )
          when :tool_result
            chat.add_message(
              role: :tool,
              content: msg[:result].to_s,
              tool_call_id: msg[:id] || "call_#{SecureRandom.hex(12)}"
            )
          end
        end
      end

      def build_tools(tools)
        return [] if tools.nil? || tools.empty?

        tools.map do |tool|
          create_dynamic_tool(tool)
        end
      end

      def create_dynamic_tool(tool_def)
        tool_name = tool_def[:name]
        tool_description = tool_def[:description]
        tool_parameters = tool_def[:parameters] || {}

        # Create a dynamic tool class for schema generation only
        tool_class = Class.new(::RubyLLM::Tool) do
          description tool_description

          properties = tool_parameters[:properties] || {}
          required_params = tool_parameters[:required] || []

          properties.each do |prop_name, prop_def|
            param prop_name.to_sym,
                  type: prop_def[:type] || "string",
                  desc: prop_def[:description],
                  required: required_params.include?(prop_name.to_s) || required_params.include?(prop_name)
          end

          define_method(:name) { tool_name }

          # Not used — tool execution is handled by the caller's tool loop
          define_method(:execute) do |**_args|
            raise "Tool execution should be handled by the caller, not by the provider"
          end
        end

        tool_class.new
      end

      def parse_response(response)
        return Response.new(error: "No response") unless response

        text = response.content.is_a?(String) ? response.content : response.content.to_s
        function_calls = parse_function_calls(response)

        Response.new(text: text, function_calls: function_calls, raw_response: response)
      end

      def parse_function_calls(response)
        return [] unless response.tool_call?

        response.tool_calls.map do |_id, tool_call|
          {
            id: tool_call.id,
            name: tool_call.name.to_s,
            args: tool_call.arguments || {}
          }
        end
      end
    end
  end
end
