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
        unless @definition.processes.include?(p)
          raise PinfileError, "process #{p} not found"
        end

        [dependencies_for(@definition.tree[p], visited + [p]), p]
      }.flatten.compact.uniq
    end

  end
end
