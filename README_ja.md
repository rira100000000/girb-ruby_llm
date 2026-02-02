# girb-ruby_llm

[girb](https://github.com/rira100000000/girb)（AI搭載IRBアシスタント）用のRubyLLMプロバイダーです。

このgemを使用すると、[RubyLLM](https://github.com/crmne/ruby_llm)の統一APIを通じて、複数のLLMプロバイダー（OpenAI、Anthropic、Google Gemini、Ollamaなど）を利用できます。

## インストール

Gemfileに追加:

```ruby
gem 'girb-ruby_llm'
```

実行:

```bash
bundle install
```

または直接インストール:

```bash
gem install girb-ruby_llm
```

## 設定

APIキーまたはエンドポイントを環境変数として設定します。最初に利用可能なキーに基づいて自動設定されます（優先順位順）:

### クラウドプロバイダー

| プロバイダー | 環境変数 | デフォルトモデル |
|-------------|---------|----------------|
| Anthropic | `ANTHROPIC_API_KEY` | `claude-sonnet-4-20250514` |
| OpenAI | `OPENAI_API_KEY` | `gpt-4o-mini` |
| Google Gemini | `GEMINI_API_KEY` | `gemini-2.0-flash` |
| DeepSeek | `DEEPSEEK_API_KEY` | `deepseek-chat` |
| Mistral | `MISTRAL_API_KEY` | `mistral-small-latest` |
| OpenRouter | `OPENROUTER_API_KEY` | `openai/gpt-4o-mini` |
| Perplexity | `PERPLEXITY_API_KEY` | `llama-3.1-sonar-small-128k-online` |
| xAI | `XAI_API_KEY` | `grok-2` |

### ローカルプロバイダー

| プロバイダー | 環境変数 | デフォルトモデル |
|-------------|---------|----------------|
| Ollama | `OLLAMA_API_BASE` | `llama3.2` |
| GPUStack | `GPUSTACK_API_BASE` | - |

### 追加設定

| 環境変数 | 説明 |
|---------|------|
| `OPENAI_API_BASE` | カスタムOpenAI互換APIエンドポイント |
| `GEMINI_API_BASE` | カスタムGemini APIエンドポイント |
| `GPUSTACK_API_KEY` | GPUStack APIキー |
| `BEDROCK_API_KEY` | AWS Bedrockアクセスキー |
| `BEDROCK_SECRET_KEY` | AWS Bedrockシークレットキー |
| `BEDROCK_REGION` | AWS Bedrockリージョン |
| `VERTEXAI_PROJECT_ID` | Google Vertex AIプロジェクトID |
| `VERTEXAI_LOCATION` | Google Vertex AIロケーション |

## 使用例

### OpenAIを使用

```bash
export OPENAI_API_KEY="sk-..."
girb
```

### Anthropic Claudeを使用

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
girb
```

### Ollama（ローカル）を使用

```bash
# まずOllamaを起動
ollama serve

# APIベースURLを設定
export OLLAMA_API_BASE="http://localhost:11434"
girb
```

### OpenAI互換API（LM Studio、vLLMなど）を使用

```bash
export OPENAI_API_KEY="not-needed"  # 空でない値が必要な場合
export OPENAI_API_BASE="http://localhost:1234/v1"
girb
```

### 手動設定

Rubyでプロバイダーを手動で設定することもできます:

```ruby
require 'girb-ruby_llm'

RubyLLM.configure do |config|
  config.ollama_api_base = "http://localhost:11434"
end

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'llama3.2')
end
```

## 対応モデル

サポートされているモデルの完全なリストは[RubyLLMドキュメント](https://rubyllm.com)を参照してください。

## 使用方法

インストールと設定が完了したら、通常通りgirbを使用するだけです:

```bash
girb
```

## ライセンス

MIT License
