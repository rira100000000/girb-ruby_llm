# frozen_string_literal: true

require "girb"
require_relative "girb/providers/ruby_llm"

# Auto-configure RubyLLM provider based on available API keys
# Priority: ANTHROPIC > OPENAI > GEMINI
if ENV["ANTHROPIC_API_KEY"] || ENV["OPENAI_API_KEY"] || ENV["GEMINI_API_KEY"]
  # Configure RubyLLM with available API keys
  RubyLLM.configure do |config|
    config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"] if ENV["ANTHROPIC_API_KEY"]
    config.openai_api_key = ENV["OPENAI_API_KEY"] if ENV["OPENAI_API_KEY"]
    config.gemini_api_key = ENV["GEMINI_API_KEY"] if ENV["GEMINI_API_KEY"]
  end

  # Select default model based on available API key
  default_model = if ENV["ANTHROPIC_API_KEY"]
                    "claude-sonnet-4-20250514"
                  elsif ENV["OPENAI_API_KEY"]
                    "gpt-4o-mini"
                  elsif ENV["GEMINI_API_KEY"]
                    "gemini-2.0-flash"
                  end

  Girb.configure do |c|
    unless c.provider
      c.provider = Girb::Providers::RubyLlm.new(
        model: c.model || default_model
      )
    end
  end
end
