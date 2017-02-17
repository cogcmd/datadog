require 'cog_cmd/datadog/dashboard'
require 'datadog/command'

module CogCmd::Datadog::Dashboard
  class List < Datadog::Command
    def run_command
      response.content = client.list_dashboards
    end
  end
end
