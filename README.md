# girb-ruby_llm

[日本語版 README](README_ja.md)

RubyLLM provider for [girb](https://github.com/rira100000000/girb) (AI-powered IRB assistant).

This gem allows you to use multiple LLM providers (OpenAI, Anthropic, Google Gemini, Ollama, and more) through the [RubyLLM](https://github.com/crmne/ruby_llm) unified API.

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

Set your API key or endpoint as an environment variable:

### Cloud Providers

| Provider | Environment Variable |
|----------|---------------------|
| Anthropic | `ANTHROPIC_API_KEY` |
| OpenAI | `OPENAI_API_KEY` |
| Google Gemini | `GEMINI_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| Mistral | `MISTRAL_API_KEY` |
| OpenRouter | `OPENROUTER_API_KEY` |
| Perplexity | `PERPLEXITY_API_KEY` |
| xAI | `XAI_API_KEY` |

### Local Providers

| Provider | Environment Variable |
|----------|---------------------|
| Ollama | `OLLAMA_API_BASE` |
| GPUStack | `GPUSTACK_API_BASE` |

### Additional Configuration

| Environment Variable | Description |
|---------------------|-------------|
| `OPENAI_API_BASE` | Custom OpenAI-compatible API endpoint |
| `GEMINI_API_BASE` | Custom Gemini API endpoint |
| `GPUSTACK_API_KEY` | GPUStack API key |
| `BEDROCK_API_KEY` | AWS Bedrock access key |
| `BEDROCK_SECRET_KEY` | AWS Bedrock secret key |
| `BEDROCK_REGION` | AWS Bedrock region |
| `VERTEXAI_PROJECT_ID` | Google Vertex AI project ID |
| `VERTEXAI_LOCATION` | Google Vertex AI location |

## Examples

### Using OpenAI

```bash
export OPENAI_API_KEY="sk-..."
girb
```

### Using Anthropic Claude

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
girb
```

### Using Ollama (Local)

```bash
# Start Ollama first
ollama serve

# Set the API base URL
export OLLAMA_API_BASE="http://localhost:11434"
girb
```

### Using OpenAI-compatible APIs (e.g., LM Studio, vLLM)

```bash
export OPENAI_API_KEY="not-needed"  # Some require any non-empty value
export OPENAI_API_BASE="http://localhost:1234/v1"
girb
```

### Manual Configuration

You can configure the provider manually in your `~/.irbrc`:

```ruby
# ~/.irbrc
require 'girb-ruby_llm'

RubyLLM.configure do |config|
  config.ollama_api_base = "http://localhost:11434"
end

Girb.configure do |c|
  c.model = 'llama3.2'
  c.provider = Girb::Providers::RubyLlm.new(model: c.model)
end
```

## Supported Models

See [RubyLLM Available Models](https://rubyllm.com/reference/available-models) for the full list of supported models.

## Usage

Once installed and configured, simply use girb as normal:

```bash
girb
```

## License

MIT License
