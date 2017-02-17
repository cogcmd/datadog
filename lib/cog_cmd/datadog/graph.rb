require 'datadog/command'
require 'active_support/all'

module CogCmd::Datadog
  class Graph < Datadog::Command
    def run_command
      query = request.args[0]
      to = Time.now
      from = to - 1.hour

      response.content = client.show_graph(query, from.to_i, to.to_i)
      response.template = 'graph'
    end
  end
end
