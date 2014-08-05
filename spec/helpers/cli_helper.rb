module Bowler
  module CLIHelper

    # stubs the behaviour of a tree with no dependencies, but stubs out all
    # the dependency-lookup behaviour and Pinfile parsing
    def stub_dependency_tree(*processes)
      mock_tree = mock('Bowler::DependencyTree')
      Bowler::DependencyTree.expects(:load).returns(mock_tree)

      mock_tree.expects(:dependencies_for).with(processes).returns(processes)
    end

  end
end
