lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strait/version'

Gem::Specification.new do |spec|
  spec.name = 'strait'
  spec.version = Strait::VERSION
  spec.authors = ['Emma Lejeck']
  spec.email = ['nuck@kitsu.io']

  spec.summary = 'Rate-limiting to defend your nation-state from pillagers'
  spec.description = <<~DESC
    Strait is a rate-limiting library designed to provide security you don't need to think about.
    Whenever you have code to protect, put a Strait in front of it.
  DESC
  spec.homepage = 'https://github.com/hummingbird-me/strait'
  spec.license = 'Apache-2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hummingbird-me/strait'
  spec.metadata["changelog_uri"] = "https://github.com/hummingbird-me/strait/releases"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,exe}/**/*') + ['strait.gemspec', 'README.md'].select { |f| File.exist?(f) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'mock_redis', '~> 0.21'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'timecop', '~> 0.9'
  spec.add_runtime_dependency 'connection_pool', '>= 2.0', '< 3.0'
  spec.add_runtime_dependency 'redis', '>= 3.0', '< 6.0'
end
