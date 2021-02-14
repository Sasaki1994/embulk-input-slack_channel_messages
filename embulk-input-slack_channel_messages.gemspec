
Gem::Specification.new do |spec|
  spec.name          = "embulk-input-slack_channel_messages"
  spec.version       = "0.1.0"
  spec.authors       = ["Sasaki1994"]
  spec.summary       = "Slack Channel Messages input plugin for Embulk"
  spec.description   = "Loads slack channel messages using slack API."
  spec.email         = ["b.92421933411@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.homepage      = "https://github.com/Sasaki1994/embulk-input-slack_channel_messages"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  # spec.add_development_dependency 'embulk', ['>= 0.9.23']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_development_dependency 'rspec'
end
