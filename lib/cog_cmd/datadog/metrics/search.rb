require 'cog_cmd/datadog/dashboard'
require 'datadog/command'

module CogCmd::Datadog::Metrics
  class Search < Datadog::Command
    def run_command
      query = request.args[0]
      response.template = 'metrics_search'
      response.content = client.search_metrics(query)
    end
  end
end
