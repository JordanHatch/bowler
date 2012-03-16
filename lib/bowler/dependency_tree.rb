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

    def dependencies_for(processes)
      processes.inject([]) do |array, p|
        array += [ (@definition.tree[p] || []), p ].flatten
      end.uniq
    end

    def process_list_for(processes)
      on = dependencies_for(processes)
      off = @definition.processes.reject {|i| on.include? i }

      [ on.map {|x| "#{x}=1" }.join(','), off.map {|x| "#{x}=0" }.join(',') ].flatten.join(',')
    end

  end
end