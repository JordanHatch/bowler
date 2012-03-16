module Bowler
  class DSL
    def self.evaluate(pinfile)
      dsl = new
      dsl.eval_pinfile(pinfile)
      dsl.to_definition
    end

    def eval_pinfile(pinfile)
      raise PinfileNotFound unless File.exists?(pinfile)
      file = File.read(pinfile)
      instance_eval( file )
    rescue SyntaxError => e
      raise PinfileError, e
    end

    def initialize
      @processes = []
      @global_dependencies = []
    end

    def dependency(*dependencies)
      @global_dependencies += [dependencies].flatten
    end

    def process(params)
      if params.is_a? Hash
        parent = params.keys.first
        dependencies = [params.values.first]

        @processes << { :process => parent, :dependencies => [dependencies].flatten }
      else
        @processes << { :process => params, :dependencies => [ ] }
      end
    end

    def to_definition
      definition = {
        :tree => @processes.each_with_object({}) {|p, hash|
          hash[p[:process]] = (p[:dependencies] + @global_dependencies).uniq
        },
        :processes => (@processes.map {|x| x[:process]} + @global_dependencies).uniq
      }
      OpenStruct.new(definition)
    end

  end
end