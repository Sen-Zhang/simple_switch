lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simple_switch/version'

Gem::Specification.new do |spec|
  spec.name        = 'simple_switch'
  spec.version     = SimpleSwitch::VERSION
  spec.authors     = ['Sen Zhang']
  spec.email       = ['solowolf21@gmail.com']
  spec.summary     = %q{Simple Feature Switch Engine}
  spec.description = %q{Simple Feature Switch Engine}
  spec.homepage    = 'https://github.com/Sen-Zhang/simple_switch'
  spec.license     = 'MIT'

  spec.files                 = `git ls-files -z`.split("\x0")
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
