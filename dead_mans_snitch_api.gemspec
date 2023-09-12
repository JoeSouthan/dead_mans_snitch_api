# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "dead_mans_snitch_api"
  spec.version       = "0.1.0"
  spec.authors       = ["Joseph Southan"]
  spec.email         = ["github@sthn.io"]

  spec.summary       = "Wrapper around deadmanssnitch.com's api"
  spec.homepage      = "https://www.github.com/joesouthan/dead_mans_snitch_api"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/joesouthan/dead_mans_snitch_api"
  spec.metadata["changelog_uri"] = "https://www.github.com/joesouthan/dead_mans_snitch_api/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable", "~> 2.7.0"
  spec.add_dependency "dry-configurable", ">= 0.11", "< 2.0"
  spec.add_dependency "dry-struct", "~> 1.3"
  spec.add_dependency "rest-client", "~> 2.1.0"
end
