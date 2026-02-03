# girb-ruby_llm

[girb](https://github.com/rira100000000/girb)（AI搭載IRBアシスタント）用のRubyLLMプロバイダーです。

このgemを使用すると、[RubyLLM](https://github.com/crmne/ruby_llm)の統一APIを通じて、複数のLLMプロバイダー（OpenAI、Anthropic、Google Gemini、Ollamaなど）を利用できます。

## インストール

### Railsプロジェクトの場合

Gemfileに追加:

```ruby
group :development do
  gem 'girb-ruby_llm'
end
```

そして実行:

```bash
bundle install
```

プロジェクトルートに `.girbrc` ファイルを作成:

```ruby
# .girbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
end
```

これで `rails console` が自動的にgirbを読み込みます！

### 非Railsプロジェクトの場合

グローバルにインストール:

```bash
gem install girb girb-ruby_llm
```

プロジェクトディレクトリに `.girbrc` ファイルを作成:

```ruby
# .girbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
end
```

`irb` の代わりに `girb` コマンドを使用します。

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

### Google Geminiを使用

```ruby
# .girbrc
require 'girb-ruby_llm'

# GEMINI_API_KEY 環境変数を設定
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
end
```

### OpenAIを使用

```ruby
# .girbrc
require 'girb-ruby_llm'

# OPENAI_API_KEY 環境変数を設定
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gpt-4o')
end
```

### Anthropic Claudeを使用

```ruby
# .girbrc
require 'girb-ruby_llm'

# ANTHROPIC_API_KEY 環境変数を設定
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'claude-sonnet-4-20250514')
end
```

### Ollama（ローカル）を使用

```ruby
# .girbrc
require 'girb-ruby_llm'

# OLLAMA_API_BASE 環境変数を設定（例: http://localhost:11434/v1）
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'llama3.2:latest')
end
```

### OpenAI互換API（LM Studio、vLLMなど）を使用

```ruby
# .girbrc
require 'girb-ruby_llm'

# OPENAI_API_BASE と OPENAI_API_KEY 環境変数を設定
Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'your-model-name')
end
```

### 詳細設定

```ruby
# .girbrc
require 'girb-ruby_llm'

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gemini-2.5-flash')
  c.debug = true  # デバッグ出力を有効化
  c.custom_prompt = <<~PROMPT
    破壊的操作の前に必ず確認してください。
  PROMPT
end
```

注: ローカルプロバイダー（Ollama、GPUStack）使用時は`RubyLLM::Models.refresh!`が自動的に呼ばれます。

## 代替: 環境変数での設定

`girb` コマンドでは、`.girbrc` が見つからない場合に環境変数で設定することもできます:

```bash
export GIRB_PROVIDER=girb-ruby_llm
export GIRB_MODEL=gemini-2.5-flash
export GEMINI_API_KEY=your-api-key
girb
```

## 対応モデル

サポートされているモデルの完全なリストは[RubyLLM Available Models](https://rubyllm.com/reference/available-models)を参照してください。

## ライセンス

MIT License
