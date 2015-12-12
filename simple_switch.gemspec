$:.push File.expand_path('../lib', __FILE__)

require 'simple_switch/version'

Gem::Specification.new do |s|
  s.name        = 'simple_switch'
  s.version     = SimpleSwitch::VERSION
  s.authors     = ['Sen Zhang']
  s.email       = ['solowolf21@gmail.com']
  s.homepage    = 'https://github.com/Sen-Zhang/simple_switch'
  s.summary     = %q{Simple Feature Switch Engine}
  s.description = %q{Simple Feature Switch Engine for Rails App}
  s.license     = 'MIT'

  s.files      = Dir['{app,config,db,lib}/**/*', 'CHANGELOG.md', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*', 'test/**/*']

  s.required_ruby_version = '>= 2.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rails', '~> 4.2', '>= 4.2.0'
  s.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
end
