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

APIキーまたはエンドポイントを環境変数として設定します:

### クラウドプロバイダー

| プロバイダー | 環境変数 |
|-------------|---------|
| Anthropic | `ANTHROPIC_API_KEY` |
| OpenAI | `OPENAI_API_KEY` |
| Google Gemini | `GEMINI_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| Mistral | `MISTRAL_API_KEY` |
| OpenRouter | `OPENROUTER_API_KEY` |
| Perplexity | `PERPLEXITY_API_KEY` |
| xAI | `XAI_API_KEY` |

### ローカルプロバイダー

| プロバイダー | 環境変数 |
|-------------|---------|
| Ollama | `OLLAMA_API_BASE` |
| GPUStack | `GPUSTACK_API_BASE` |

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

Rubyでプロバイダーを手動で設定できます:

```ruby
require 'girb-ruby_llm'

RubyLLM.configure do |config|
  config.ollama_api_base = "http://localhost:11434"
end

Girb.configure do |c|
  c.model = 'llama3.2'
  c.provider = Girb::Providers::RubyLlm.new(model: c.model)
end
```

## 対応モデル

サポートされているモデルの完全なリストは[RubyLLM Available Models](https://rubyllm.com/reference/available-models)を参照してください。

## 使用方法

インストールと設定が完了したら、通常通りgirbを使用するだけです:

```bash
girb
```

## ライセンス

MIT License
