# frozen_string_literal: true

require "ruby_llm"
require "girb/providers/base"

module Girb
  module Providers
    class RubyLlm < Base
      # Thread-local storage for current binding
      def self.current_binding=(binding)
        Thread.current[:girb_ruby_llm_binding] = binding
      end

      def self.current_binding
        Thread.current[:girb_ruby_llm_binding]
      end

      def initialize(model: nil)
        @model = model
      end

      def chat(messages:, system_prompt:, tools:, binding: nil)
        # Store binding for tool execution
        self.class.current_binding = binding

        # Use specified model or RubyLLM's default
        chat_options = @model ? { model: @model } : {}
        ruby_llm_chat = ::RubyLLM.chat(**chat_options)

        # Set system prompt
        ruby_llm_chat.with_instructions(system_prompt) if system_prompt && !system_prompt.empty?

        # Add tools
        tool_instances = build_tools(tools)
        tool_instances.each { |tool| ruby_llm_chat.with_tool(tool) }

        # Add messages except the last user message
        add_messages_to_chat(ruby_llm_chat, messages[0..-2])

        # Get the last user message
        last_message = messages.last
        last_content = extract_content(last_message)

        # Send the request - RubyLLM will auto-execute tools
        response = ruby_llm_chat.ask(last_content)

        parse_response(response)
      rescue Faraday::BadRequestError => e
        Response.new(error: "API Error: #{e.message}")
      rescue StandardError => e
        Response.new(error: "Error: #{e.message}")
      ensure
        self.class.current_binding = nil
      end

      private

      def add_messages_to_chat(chat, messages)
        messages.each do |msg|
          case msg[:role]
          when :user
            chat.add_message(role: :user, content: msg[:content])
          when :assistant
            chat.add_message(role: :assistant, content: msg[:content])
          when :tool_call
            # Add as assistant message with tool_calls
            chat.add_message(
              role: :assistant,
              content: nil,
              tool_calls: {
                msg[:name] => ::RubyLLM::ToolCall.new(
                  id: msg[:id] || "call_#{SecureRandom.hex(12)}",
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

      def extract_content(message)
        case message[:role]
        when :user, :assistant
          message[:content]
        else
          message[:content].to_s
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

        # Create a dynamic tool class
        tool_class = Class.new(::RubyLLM::Tool) do
          description tool_description

          # Define parameters
          properties = tool_parameters[:properties] || {}
          required_params = tool_parameters[:required] || []

          properties.each do |prop_name, prop_def|
            param prop_name.to_sym,
                  type: prop_def[:type] || "string",
                  desc: prop_def[:description],
                  required: required_params.include?(prop_name.to_s) || required_params.include?(prop_name)
          end

          # Store tool_name for execute method and override name for RubyLLM
          define_method(:girb_tool_name) { tool_name }
          define_method(:name) { tool_name }

          # Execute method - actually execute the girb tool
          define_method(:execute) do |**args|
            tool_name_for_log = girb_tool_name

            if Girb.configuration&.debug
              args_str = args.map { |k, v| "#{k}: #{v.inspect}" }.join(", ")
              puts "[girb] Tool: #{tool_name_for_log}(#{args_str})"
            end

            binding = Girb::Providers::RubyLlm.current_binding
            girb_tool_class = Girb::Tools.find_tool(tool_name_for_log)

            unless girb_tool_class
              return { error: "Unknown tool: #{tool_name_for_log}" }
            end

            girb_tool = girb_tool_class.new

            result = if binding
                       girb_tool.execute(binding, **args)
                     else
                       { error: "No binding available for tool execution" }
                     end

            if Girb.configuration&.debug && result.is_a?(Hash) && result[:error]
              puts "[girb] Tool error: #{result[:error]}"
            end

            result
          rescue StandardError => e
            { error: "Tool execution failed: #{e.class} - #{e.message}" }
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
            name: tool_call.name.to_s,
            args: tool_call.arguments || {}
          }
        end
      end
    end
  end
end
