require_relative 'spec_helper'
require 'bowler/cli'

module Bowler

  describe CLI do

    context "build_command" do
      it "should build a command from the launch string and the executable" do
        CLI.expects(:foreman_exec).returns("fort")
        CLI.build_command("foo").should == "fort start -c foo"
      end
    end

    context "foreman_exec" do
      before(:each) do
        @existing_env_var = ENV["BOWLER_FOREMAN_EXEC"]
        ENV["BOWLER_FOREMAN_EXEC"] = nil
      end

      after(:each) do
        ENV["BOWLER_FOREMAN_EXEC"] = @existing_env_var
      end

      it "should return the BOWLER_FOREMAN_EXEC env variable when set" do
        ENV["BOWLER_FOREMAN_EXEC"] = "a_process"
        CLI.foreman_exec.should == "a_process"
      end

      it "should return 'foreman' when the env variable is empty" do
        ENV["BOWLER_FOREMAN_EXEC"] = nil
        CLI.foreman_exec.should == "foreman"
      end
    end

  end

end
