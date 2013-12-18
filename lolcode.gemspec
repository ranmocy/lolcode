$LOAD_PATH.push(File.expand_path('../lib', __FILE__)).uniq!

Gem::Specification.new do |spec|
  spec.name          = "lolcode"
  spec.version       = File.open('VERSION') { |f| f.read }
  spec.authors       = ["Ranmocy Sheng"]
  spec.email         = ["ranmocy@gmail.com"]
  spec.description   = %q{LOLCODE interpreter for English and Chinese}
  spec.summary       = %q{LOLCODE interpreter for English and Chinese version stand on Ruby}
  spec.homepage      = "https://github.com/ranmocy/lolcode"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "version"
end
