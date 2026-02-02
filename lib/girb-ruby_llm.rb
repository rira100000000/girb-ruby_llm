# frozen_string_literal: true

require "girb"
require_relative "girb/providers/ruby_llm"

# Environment variable to API key/config mapping
RUBY_LLM_CONFIG_MAP = {
  # Cloud providers (API key based)
  "ANTHROPIC_API_KEY" => { config: :anthropic_api_key, model: "claude-sonnet-4-20250514" },
  "OPENAI_API_KEY" => { config: :openai_api_key, model: "gpt-4o-mini" },
  "GEMINI_API_KEY" => { config: :gemini_api_key, model: "gemini-2.0-flash" },
  "DEEPSEEK_API_KEY" => { config: :deepseek_api_key, model: "deepseek-chat" },
  "MISTRAL_API_KEY" => { config: :mistral_api_key, model: "mistral-small-latest" },
  "OPENROUTER_API_KEY" => { config: :openrouter_api_key, model: "openai/gpt-4o-mini" },
  "PERPLEXITY_API_KEY" => { config: :perplexity_api_key, model: "llama-3.1-sonar-small-128k-online" },
  "XAI_API_KEY" => { config: :xai_api_key, model: "grok-2" },
  # Local providers (URL based)
  "OLLAMA_API_BASE" => { config: :ollama_api_base, model: "llama3.2" },
  "GPUSTACK_API_BASE" => { config: :gpustack_api_base, model: nil }
}.freeze

# Additional configs that don't determine the default provider
RUBY_LLM_EXTRA_CONFIGS = {
  "OPENAI_API_BASE" => :openai_api_base,
  "GEMINI_API_BASE" => :gemini_api_base,
  "GPUSTACK_API_KEY" => :gpustack_api_key,
  "BEDROCK_API_KEY" => :bedrock_api_key,
  "BEDROCK_SECRET_KEY" => :bedrock_secret_key,
  "BEDROCK_REGION" => :bedrock_region,
  "BEDROCK_SESSION_TOKEN" => :bedrock_session_token,
  "VERTEXAI_PROJECT_ID" => :vertexai_project_id,
  "VERTEXAI_LOCATION" => :vertexai_location
}.freeze

# Find the first available provider
first_available = RUBY_LLM_CONFIG_MAP.find { |env_var, _| ENV[env_var] }

if first_available
  # Configure RubyLLM with all available API keys
  RubyLLM.configure do |config|
    # Set primary configs
    RUBY_LLM_CONFIG_MAP.each do |env_var, settings|
      config.send("#{settings[:config]}=", ENV[env_var]) if ENV[env_var]
    end

    # Set extra configs
    RUBY_LLM_EXTRA_CONFIGS.each do |env_var, config_key|
      config.send("#{config_key}=", ENV[env_var]) if ENV[env_var]
    end
  end

  # Get default model from first available provider
  default_model = first_available[1][:model]

  Girb.configure do |c|
    unless c.provider
      c.provider = Girb::Providers::RubyLlm.new(
        model: c.model || default_model
      )
    end
  end
end
