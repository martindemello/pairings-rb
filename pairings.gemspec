# frozen_string_literal: true

require_relative "lib/pairings/version"

GITHUB = "https://github.com/martindemello/pairings-rb"

Gem::Specification.new do |spec|
  spec.name = "pairings"
  spec.version = Pairings::VERSION
  spec.authors = ["Martin DeMello"]
  spec.email = ["martindemello@gmail.com"]

  spec.summary = "Tournament pairing algorithms."
  spec.description = "Implements various pairing algorithms for tournaments."
  spec.homepage = GITHUB
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = GITHUB
  spec.metadata["changelog_uri"] = "#{GITHUB}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # https://github.com/jaredbeck/graph_matching
  spec.add_dependency 'graph_matching'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
