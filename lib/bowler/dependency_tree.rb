module Bowler

  class DependencyTree

    # Load the Pinfile
    def self.load(absolute_path = nil)
      absolute_path ||= File.join( Dir.pwd, 'Pinfile' )
      definition = DSL.evaluate(absolute_path)
      self.new(definition)
    end

    def initialize(definition)
      @definition = definition
    end

    def dependencies_for(processes, visited = [])
      return [] unless processes
      (processes - visited).map { |p|
        [dependencies_for(@definition.tree[p], visited + [p]), p]
      }.flatten.compact.uniq
    end

    def process_list_for(processes)
      on = dependencies_for(processes)
      off = @definition.processes - on

      [ on.map {|x| "#{x}=1" }, off.map {|x| "#{x}=0" } ].flatten.sort.join(',')
    end

  end
end
