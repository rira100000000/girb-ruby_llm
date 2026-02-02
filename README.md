# girb-ruby_llm

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

Set your API key or endpoint as an environment variable. The provider will auto-configure based on the first available key (in priority order):

### Cloud Providers

| Provider | Environment Variable | Default Model |
|----------|---------------------|---------------|
| Anthropic | `ANTHROPIC_API_KEY` | `claude-sonnet-4-20250514` |
| OpenAI | `OPENAI_API_KEY` | `gpt-4o-mini` |
| Google Gemini | `GEMINI_API_KEY` | `gemini-2.0-flash` |
| DeepSeek | `DEEPSEEK_API_KEY` | `deepseek-chat` |
| Mistral | `MISTRAL_API_KEY` | `mistral-small-latest` |
| OpenRouter | `OPENROUTER_API_KEY` | `openai/gpt-4o-mini` |
| Perplexity | `PERPLEXITY_API_KEY` | `llama-3.1-sonar-small-128k-online` |
| xAI | `XAI_API_KEY` | `grok-2` |

### Local Providers

| Provider | Environment Variable | Default Model |
|----------|---------------------|---------------|
| Ollama | `OLLAMA_API_BASE` | `llama3.2` |
| GPUStack | `GPUSTACK_API_BASE` | - |

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

You can also configure the provider manually in Ruby:

```ruby
require 'girb-ruby_llm'

RubyLLM.configure do |config|
  config.ollama_api_base = "http://localhost:11434"
end

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'llama3.2')
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
