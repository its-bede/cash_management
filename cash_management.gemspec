# frozen_string_literal: true

require_relative "lib/cash_management/version"

Gem::Specification.new do |spec|
  spec.name = "cash_management"
  spec.version = CashManagement::VERSION
  spec.authors = ["Benjamin Deutscher"]
  spec.email = ["ben@bdeutscher.org"]

  spec.summary = "A Ruby gem for handling cash management operations and bank statements"
  spec.description = "Cash Management provides tools for parsing and handling bank statements in various formats"
  spec.homepage = "https://github.com/bdeutscher/cash_management"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "nokogiri", "~> 1.8"
  spec.add_dependency "zeitwerk", "~> 2.7"

  # Development dependencies - use add_development_dependency for backward compatibility
  spec.add_development_dependency "rubocop", "~> 1.65"
  spec.add_development_dependency "rubocop-minitest", "~> 0.35"
  spec.add_development_dependency "rubocop-performance", "~> 1.20"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
