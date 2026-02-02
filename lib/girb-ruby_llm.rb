# frozen_string_literal: true

require "girb"
require_relative "girb/providers/ruby_llm"

# Environment variable to RubyLLM config mapping
RUBY_LLM_CONFIG_MAP = {
  # Cloud providers (API key based)
  "ANTHROPIC_API_KEY" => :anthropic_api_key,
  "OPENAI_API_KEY" => :openai_api_key,
  "GEMINI_API_KEY" => :gemini_api_key,
  "DEEPSEEK_API_KEY" => :deepseek_api_key,
  "MISTRAL_API_KEY" => :mistral_api_key,
  "OPENROUTER_API_KEY" => :openrouter_api_key,
  "PERPLEXITY_API_KEY" => :perplexity_api_key,
  "XAI_API_KEY" => :xai_api_key,
  # Local providers (URL based)
  "OLLAMA_API_BASE" => :ollama_api_base,
  "GPUSTACK_API_BASE" => :gpustack_api_base,
  "GPUSTACK_API_KEY" => :gpustack_api_key,
  # Additional configs
  "OPENAI_API_BASE" => :openai_api_base,
  "GEMINI_API_BASE" => :gemini_api_base,
  "BEDROCK_API_KEY" => :bedrock_api_key,
  "BEDROCK_SECRET_KEY" => :bedrock_secret_key,
  "BEDROCK_REGION" => :bedrock_region,
  "BEDROCK_SESSION_TOKEN" => :bedrock_session_token,
  "VERTEXAI_PROJECT_ID" => :vertexai_project_id,
  "VERTEXAI_LOCATION" => :vertexai_location
}.freeze

# Check if any RubyLLM config is available
has_config = RUBY_LLM_CONFIG_MAP.any? { |env_var, _| ENV[env_var] }

# Local providers that require Models.refresh!
LOCAL_PROVIDERS = %w[OLLAMA_API_BASE GPUSTACK_API_BASE].freeze

if has_config
  # Configure RubyLLM with all available environment variables
  RubyLLM.configure do |config|
    RUBY_LLM_CONFIG_MAP.each do |env_var, config_key|
      config.send("#{config_key}=", ENV[env_var]) if ENV[env_var]
    end
  end

  # Refresh models for local providers (Ollama, GPUStack)
  if LOCAL_PROVIDERS.any? { |env_var| ENV[env_var] }
    RubyLLM::Models.refresh!
  end

  model = ENV["GIRB_MODEL"]
  unless model
    warn "[girb-ruby_llm] GIRB_MODEL not set. Please specify a model."
    warn "[girb-ruby_llm]   Example: export GIRB_MODEL=gemini-2.5-flash"
  end

  Girb.configure do |c|
    c.provider ||= Girb::Providers::RubyLlm.new(model: model)
  end
end
