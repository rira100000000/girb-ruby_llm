# Changelog

## [0.1.2] - 2026-02-03

### Fixed

- Fix tool names being empty strings in dynamic RubyLLM::Tool classes
- Properly execute girb tools within RubyLLM's auto-execute framework

## [0.1.1] - 2026-02-03

### Added

- GIRB_MODEL environment variable support (required)
- Auto-refresh models for local providers (Ollama, GPUStack)

### Changed

- Recommend ~/.irbrc configuration instead of environment variables

## [0.1.0] - 2025-02-02

### Added

- Initial release
- RubyLLM provider for girb
- Support for multiple LLM providers: OpenAI, Anthropic, Gemini, Ollama, DeepSeek, Mistral, and more
- Auto-configuration via environment variables
- Function calling support
