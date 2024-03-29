# frozen_string_literal: true

require_relative 'lib/simpal/constants'

Gem::Specification.new do |spec|
  spec.name = 'simpal'
  spec.version = Simpal::VERSION
  spec.authors = ['Nialto Services']
  spec.email = ['support@nialtoservices.co.uk']

  spec.summary = "A simple, lightweight wrapper around PayPal's REST API."
  spec.homepage = 'https://github.com/NialtoServices/simpal'
  spec.license = 'Apache-2.0'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/NialtoServices/simpal'
  spec.metadata['changelog_uri'] = 'https://github.com/NialtoServices/simpal/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'faraday', '~> 2.0'

  spec.add_development_dependency 'guard', '~> 2.18'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.39'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.15'
  spec.add_development_dependency 'sinatra', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
