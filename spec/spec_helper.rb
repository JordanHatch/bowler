gem_path = File.dirname(__FILE__) + "/../lib"
$:.unshift(gem_path) unless $:.include?(gem_path)

require 'rspec/core'
require 'bowler'

require_relative 'helpers/definition_helper'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
