require_relative 'spec_helper'
require 'bowler/cli'

module Bowler

  describe CLI do

    include CLIHelper

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

    context 'excluding an app' do
      it 'removes a given app from the list of apps passed to Foreman' do
        stub_dependency_tree(:myapp, :myapp2)

        CLI.expects(:start_foreman_with).with('myapp2=1')

        CLI.start(['myapp', 'myapp2', '--without', 'myapp'])
      end

      it 'excludes more than one app from the list of apps passed to Foreman' do
        stub_dependency_tree(:myapp, :myapp2, :myapp3)

        CLI.expects(:start_foreman_with).with('myapp3=1')

        CLI.start(['myapp', 'myapp2', 'myapp3', '--without', 'myapp', '--without', 'myapp2'])
      end

      it 'supports the short-hand argument form Foreman' do
        stub_dependency_tree(:myapp, :myapp2)

        CLI.expects(:start_foreman_with).with('myapp2=1')

        CLI.start(['myapp', 'myapp2', '-w', 'myapp'])
      end
    end

    it 'starts foreman with the provided processes' do
      stub_dependency_tree(:a, :b)

      CLI.expects(:start_foreman_with).with('a=1,b=1')

      CLI.start(['a', 'b'])
    end
  end

end
