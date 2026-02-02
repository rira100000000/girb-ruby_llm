# girb-ruby_llm

[girb](https://github.com/rira100000000/girb)（AI搭載IRBアシスタント）用のRubyLLMプロバイダーです。

このgemを使用すると、[RubyLLM](https://github.com/crmne/ruby_llm)の統一APIを通じて、複数のLLMプロバイダー（OpenAI、Anthropic、Google Gemini、Ollamaなど）を利用できます。

## インストール

Gemfileに追加:

```ruby
gem 'girb'
gem 'girb-ruby_llm'
```

または直接インストール:

```bash
gem install girb girb-ruby_llm
```

## セットアップ

プロバイダー、モデル、APIキーを設定:

```bash
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=gemini-2.5-flash  # 使用するモデルを指定
export GEMINI_API_KEY=your-api-key  # または他のプロバイダーのAPIキー
```

girbを起動:

```bash
girb
```

### 通常のirbで使用する場合

`~/.irbrc` に追加:

```ruby
require 'girb-ruby_llm'
```

通常の `irb` コマンドで使用できます。

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
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=gpt-4o
export OPENAI_API_KEY="sk-..."
girb
```

### Anthropic Claudeを使用

```bash
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=claude-sonnet-4-20250514
export ANTHROPIC_API_KEY="sk-ant-..."
girb
```

### Ollama（ローカル）を使用

```bash
# まずOllamaを起動
ollama serve

# プロバイダー、モデル、APIベースURLを設定
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=llama3.2:latest
export OLLAMA_API_BASE="http://localhost:11434/v1"
girb
```

### OpenAI互換API（LM Studio、vLLMなど）を使用

```bash
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=your-model-name
export OPENAI_API_KEY="not-needed"  # 空でない値が必要な場合
export OPENAI_API_BASE="http://localhost:1234/v1"
girb
```

### 詳細設定

より細かい制御が必要な場合、`~/.irbrc`でGirbを設定できます:

```ruby
# ~/.irbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.debug = true  # デバッグ出力を有効化
  c.custom_prompt = <<~PROMPT
    破壊的操作の前に必ず確認してください。
  PROMPT
end
```

注: ローカルプロバイダー（Ollama、GPUStack）使用時は`RubyLLM::Models.refresh!`が自動的に呼ばれます。

## 対応モデル

サポートされているモデルの完全なリストは[RubyLLM Available Models](https://rubyllm.com/reference/available-models)を参照してください。

## ライセンス

MIT License
