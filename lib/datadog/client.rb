require 'datadog'
require 'dogapi'

class Datadog::Client
  attr_reader :client

  def initialize(api_key, application_key)
    @client = Dogapi::Client.new(api_key, application_key)
  end

  def list_dashboards
    status, json = client.get_dashboards
    json["dashes"]
  end

  def show_graph(query, from, to)
    status, json = client.graph_snapshot(query, from, to)
    [json]
  end
end
