# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bowler/version'

Gem::Specification.new do |s|
  s.name        = "bowler"
  s.version     = Bowler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jordan Hatch"]
  s.email       = ["jordan@jordanh.net"]
  s.summary     = %q{A wrapper for large Foreman-managed apps with dependent processes}

  s.files        = Dir.glob("lib/**/*") + %w(README.md Rakefile)
  s.test_files   = Dir['test/**/*']
  s.require_path = 'lib'

  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        = %w(bowl)
  s.require_paths      = ["lib"]

  s.add_dependency 'foreman', '>= 0.35.0'

  s.add_development_dependency 'rake', '~> 0.9.2.2'
  s.add_development_dependency 'rspec-core', '~> 2.14.7'
  s.add_development_dependency 'rspec-expectations', '~> 2.14.4'
  s.add_development_dependency 'mocha', '~> 0.14.0'
end
