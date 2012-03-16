require 'logger'

module Bowler
  class CLI

    def self.start(processes)
      tree = Bowler::DependencyTree.load
      process_list = processes.map(&:to_sym)

      launch_string = tree.process_list_for(process_list)

      logger.info "Starting #{tree.dependencies_for(process_list).join(', ')}.."

      start_foreman_with launch_string
    rescue PinfileNotFound
      logger.error "Bowler could not find a Pinfile in the current directory."
    rescue PinfileError => e
      logger.error "Bowler could not load the Pinfile due to an error: #{e}"
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.build_command(launch_string)
      "foreman start -c #{launch_string}"
    end

    private
    def self.start_foreman_with(launch_string)
      exec ( self.build_command launch_string )
    end

  end
end