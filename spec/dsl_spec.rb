require_relative 'spec_helper'
require 'bowler/dsl'

module Bowler

  describe DSL do

    include DefinitionHelper

    context "given a valid pinfile" do
      it "should return a valid definition" do
        path_to_pinfile = File.join( File.dirname(__FILE__), 'fixtures', 'dsl_valid_pinfile' )
        definition = DSL.evaluate path_to_pinfile

        definition.should be_instance_of OpenStruct
        definition.tree.should == {
          :app => [ :database, :tiles, :templates ],
          :tiles => [ :database, :templates ]
        }
        definition.processes.should =~ [ :app, :database, :templates, :tiles ]
      end
    end

    context "given an invalid pinfile" do
      it "should raise a gem-defined exception" do
        path_to_pinfile = File.join( File.dirname(__FILE__), 'fixtures', 'dsl_invalid_pinfile' )
        expect do
          DSL.evaluate path_to_pinfile
        end.to raise_error(PinfileError)
      end
    end

    context "given a process" do
      before do
        @dsl = DSL.new
        @dsl.process :test
      end

      it "should update the processes list with the specified process" do
        @dsl.processes.should == [{ :process => :test, :dependencies => [] }]
        @dsl.to_definition.processes.should == [ :test ]
      end
    end

    context "given a process with dependencies" do
      before do
        @dsl = DSL.new
        @dsl.process :test => [ :dependency1, :dependency2 ]
      end

      it "should update the processes list with all specified processes" do
        @dsl.processes.should == [{ :process => :test, :dependencies => [:dependency1, :dependency2] }]
        @dsl.to_definition.processes.should =~ [ :dependency1, :dependency2, :test ]
      end
    end

    context "given global dependencies" do
      before do
        @dsl = DSL.new
        @dsl.dependency :global1, :global2
        @dsl.dependency :global3
      end

      it "should update the processes list with all specified processes" do
        @dsl.global_dependencies.should =~ [:global1, :global2, :global3]
        @dsl.to_definition.processes.should =~ [ :global1, :global2, :global3 ]
      end
    end

  end

end