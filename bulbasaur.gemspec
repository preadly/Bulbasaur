# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "bulbasaur"
  spec.version       = "0.1"
  spec.authors       = ["Magno Costa"]
  spec.email         = ["magnocosta.br@gmail.com"]
  spec.description = spec.summary = %q(Bulbasaur is a helper for crawler operations used in Pread.ly)
  spec.homepage      = "https://github.com/preadly/bulbasaur"

  spec.files         = "git ls-files -z".split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "nokogiri"
end
