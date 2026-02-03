# girb-ruby_llm

[日本語版 README](README_ja.md)

RubyLLM provider for [girb](https://github.com/rira100000000/girb) (AI-powered IRB assistant).

This gem allows you to use multiple LLM providers (OpenAI, Anthropic, Google Gemini, Ollama, and more) through the [RubyLLM](https://github.com/crmne/ruby_llm) unified API.

## Installation

### For Rails Projects

Add to your Gemfile:

```ruby
group :development do
  gem 'girb-ruby_llm'
end
```

Then run:

```bash
bundle install
```

Create a `.girbrc` file in your project root:

```ruby
# .girbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
end
```

Now `rails console` will automatically load girb!

### For Non-Rails Projects

Install globally:

```bash
gem install girb girb-ruby_llm
```

Create a `.girbrc` file in your project directory:

```ruby
# .girbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
end
```

Then use `girb` command instead of `irb`.

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

### Using Google Gemini

```ruby
# .girbrc
require 'girb-ruby_llm'

# Set GEMINI_API_KEY environment variable
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
end
```

### Using OpenAI

```ruby
# .girbrc
require 'girb-ruby_llm'

# Set OPENAI_API_KEY environment variable
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gpt-4o')
end
```

### Using Anthropic Claude

```ruby
# .girbrc
require 'girb-ruby_llm'

# Set ANTHROPIC_API_KEY environment variable
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'claude-sonnet-4-20250514')
end
```

### Using Ollama (Local)

```ruby
# .girbrc
require 'girb-ruby_llm'

# Set OLLAMA_API_BASE environment variable (e.g., http://localhost:11434/v1)
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'llama3.2:latest')
end
```

### Using OpenAI-compatible APIs (e.g., LM Studio, vLLM)

```ruby
# .girbrc
require 'girb-ruby_llm'

# Set OPENAI_API_BASE and OPENAI_API_KEY environment variables
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'your-model-name')
end
```

### Advanced Configuration

```ruby
# .girbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
  c.debug = true  # Enable debug output
  c.custom_prompt = <<~PROMPT
    Always confirm before destructive operations.
  PROMPT
end
```

Note: `RubyLLM::Models.refresh!` is automatically called for local providers (Ollama, GPUStack).

## Alternative: Environment Variable Configuration

For the `girb` command, you can also configure via environment variables (used when no `.girbrc` is found):

```bash
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=gemini-2.5-flash
export GEMINI_API_KEY=your-api-key
girb
```

## Supported Models

See [RubyLLM Available Models](https://rubyllm.com/reference/available-models) for the full list of supported models.

## License

MIT License
