# girb-ruby_llm

RubyLLM provider for [girb](https://github.com/rira100000000/girb) (AI-powered IRB assistant).

This gem allows you to use multiple LLM providers (OpenAI, Anthropic, Google Gemini, and more) through the [RubyLLM](https://github.com/crmne/ruby_llm) unified API.

## Installation

Add to your Gemfile:

```ruby
gem 'girb-ruby_llm'
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install girb-ruby_llm
```

## Configuration

Set your API key as an environment variable. The provider will auto-configure based on available keys:

```bash
# For Anthropic Claude (priority 1)
export ANTHROPIC_API_KEY="your-anthropic-api-key"

# For OpenAI (priority 2)
export OPENAI_API_KEY="your-openai-api-key"

# For Google Gemini (priority 3)
export GEMINI_API_KEY="your-gemini-api-key"
```

### Default Models

- **Anthropic**: `claude-sonnet-4-20250514`
- **OpenAI**: `gpt-4o-mini`
- **Gemini**: `gemini-2.0-flash`

### Manual Configuration

You can also configure the provider manually:

```ruby
require 'girb-ruby_llm'

RubyLLM.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
end

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gpt-4o')
end
```

## Supported Models

Thanks to RubyLLM, this provider supports 800+ models from various providers:

- **OpenAI**: GPT-4o, GPT-4o-mini, GPT-4, o1, o3-mini, etc.
- **Anthropic**: Claude Opus 4, Claude Sonnet 4, Claude 3.5, etc.
- **Google**: Gemini 2.0, Gemini 1.5, etc.
- **DeepSeek**: DeepSeek-V3, DeepSeek-R1, etc.
- **And more**: Mistral, Ollama (local models), OpenRouter, etc.

See [RubyLLM documentation](https://rubyllm.com) for the full list of supported models.

## Usage

Once installed and configured, simply use girb as normal:

```bash
girb
```

## License

MIT License
