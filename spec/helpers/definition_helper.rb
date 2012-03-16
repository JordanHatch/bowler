module Bowler
  module DefinitionHelper

    require 'ostruct'

    def stub_definition
      OpenStruct.new ({
        :processes => [ :app1, :app2, :app3 ],
        :tree => {
          :app1 => [ :app2, :app3 ],
          :app2 => [ :app3 ],
          :app3 => [ ],
          :other => [ :a, :b, :c ]
        }
      })
    end

  end
end