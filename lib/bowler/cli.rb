require 'logger'
require 'optparse'

module Bowler
  class CLI

    def self.start(args)
      tree = Bowler::DependencyTree.load

      options = {
        without: []
      }
      OptionParser.new {|opts|
        opts.on('-w', '--without APP', 'Exclude a process from being launched') do |process|
          options[:without] << process.to_sym
        end
      }.parse!(args)

      processes = args.map(&:to_sym)

      to_launch = tree.dependencies_for(processes) - options[:without]
      logger.info "Starting #{to_launch.join(', ')}.."

      start_foreman_with( launch_string(to_launch) )
    rescue PinfileNotFound
      logger.error "Bowler could not find a Pinfile in the current directory."
    rescue PinfileError => e
      logger.error "Bowler could not load the Pinfile due to an error: #{e}"
    end

    def self.logger
      @@logger ||= Logger.new(STDOUT)
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.build_command(launch_string)
      "#{self.foreman_exec} start -c #{launch_string}"
    end

  private
    def self.launch_string(processes)
      processes.map {|process|
        "#{process}=1"
      }.sort.join(',')
    end

    def self.start_foreman_with(launch_string)
      exec ( self.build_command launch_string )
    end

    def self.foreman_exec
      ENV["BOWLER_FOREMAN_EXEC"] || "foreman"
    end

  end
end
