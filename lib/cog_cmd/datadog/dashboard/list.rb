require 'cog_cmd/datadog/dashboard'

module CogCmd::Datadog::Dashboard
  class List < Cog::Command
    def run_command
      response.content = [{name: 'test_dashboard'}]
    end
  end
end
