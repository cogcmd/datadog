require 'cog_cmd/datadog/metric'
require 'datadog/command'

module CogCmd::Datadog::Metric
  class Search < Datadog::Command
    def run_command
      query = request.args[0]
      response.template = 'metric_search'
      response.content = client.search_metrics(query)
    end
  end
end
