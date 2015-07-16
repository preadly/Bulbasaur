# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './lib/bulbasaur/version'

Gem::Specification.new do |spec|
  spec.name          = "preadly-bulbasaur"
  spec.version       = Bulbasaur::Version::STRING
  spec.authors       = ["Magno Costa"]
  spec.email         = ["magnocosta.br@gmail.com"]
  spec.description = spec.summary = %q(Bulbasaur is a helper for crawler operations used in Pread.ly)
  spec.homepage      = "https://github.com/preadly/bulbasaur"

  spec.files         = Dir["{lib/**/*.rb,README.rdoc,spec/**/*.rb,Rakefile,*.gemspec}"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "webmock"


  spec.add_dependency "nokogiri", "~> 1.6"
end
