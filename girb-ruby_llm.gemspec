# frozen_string_literal: true

require_relative "lib/girb-ruby_llm/version"

Gem::Specification.new do |spec|
  spec.name = "girb-ruby_llm"
  spec.version = GirbRubyLlm::VERSION
  spec.authors = ["rira100000000"]
  spec.email = ["101010hayakawa@gmail.com"]

  spec.summary = "RubyLLM provider for girb"
  spec.description = "RubyLLM provider for girb (AI-powered IRB assistant). " \
                     "Install this gem to use OpenAI, Anthropic, Gemini and other LLMs via RubyLLM as your LLM backend."
  spec.homepage = "https://github.com/rira100000000/girb-ruby_llm"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "girb", "~> 0.1"
  spec.add_dependency "ruby_llm", "~> 1.0"
end
