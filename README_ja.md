# girb-ruby_llm

[girb](https://github.com/rira100000000/girb)（AI搭載IRBアシスタント）用のRubyLLMプロバイダーです。

このgemを使用すると、[RubyLLM](https://github.com/crmne/ruby_llm)の統一APIを通じて、複数のLLMプロバイダー（OpenAI、Anthropic、Google Geminiなど）を利用できます。

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

APIキーを環境変数として設定します。利用可能なキーに基づいて自動設定されます:

```bash
# Anthropic Claude（優先度1）
export ANTHROPIC_API_KEY="your-anthropic-api-key"

# OpenAI（優先度2）
export OPENAI_API_KEY="your-openai-api-key"

# Google Gemini（優先度3）
export GEMINI_API_KEY="your-gemini-api-key"
```

### デフォルトモデル

- **Anthropic**: `claude-sonnet-4-20250514`
- **OpenAI**: `gpt-4o-mini`
- **Gemini**: `gemini-2.0-flash`

### 手動設定

プロバイダーを手動で設定することもできます:

```ruby
require 'girb-ruby_llm'

RubyLLM.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
end

Girb.configure do |c|
  c.provider = Girb::Providers::RubyLlm.new(model: 'gpt-4o')
end
```

## 対応モデル

RubyLLMのおかげで、このプロバイダーは様々なプロバイダーから800以上のモデルをサポートしています:

- **OpenAI**: GPT-4o, GPT-4o-mini, GPT-4, o1, o3-miniなど
- **Anthropic**: Claude Opus 4, Claude Sonnet 4, Claude 3.5など
- **Google**: Gemini 2.0, Gemini 1.5など
- **DeepSeek**: DeepSeek-V3, DeepSeek-R1など
- **その他**: Mistral, Ollama（ローカルモデル）, OpenRouterなど

サポートされているモデルの完全なリストは[RubyLLMドキュメント](https://rubyllm.com)を参照してください。

## 使用方法

インストールと設定が完了したら、通常通りgirbを使用するだけです:

```bash
girb
```

## ライセンス

MIT License
