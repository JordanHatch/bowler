require 'ostruct'

module Bowler

  autoload :CLI,                  'bowler/cli'
  autoload :DependencyTree,       'bowler/dependency_tree'
  autoload :DSL,                  'bowler/dsl'

  class PinfileNotFound < Exception; end
  class PinfileError < Exception; end

end
