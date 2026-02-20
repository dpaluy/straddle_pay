# frozen_string_literal: true

require_relative "lib/straddle_pay/version"

Gem::Specification.new do |spec|
  spec.name = "straddle_pay"
  spec.version = StraddlePay::VERSION
  spec.authors = ["dpaluy"]
  spec.email = ["dpaluy@users.noreply.github.com"]

  spec.summary = "Ruby client for the Straddle payment infrastructure API."
  spec.description = "StraddlePay provides a lightweight Faraday-based wrapper for Straddle's payment API " \
                     "including charges, payouts, customers, bridge, paykeys, and embedded account management."
  spec.homepage = "https://github.com/dpaluy/straddle_pay"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/straddle_pay"
  spec.metadata["source_code_uri"] = "https://github.com/dpaluy/straddle_pay"
  spec.metadata["changelog_uri"] = "https://github.com/dpaluy/straddle_pay/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/dpaluy/straddle_pay/issues"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml docs/ AGENTS.md CLAUDE.md Rakefile])
    end
  end
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]

  spec.add_dependency "faraday", "~> 2.9"
end
