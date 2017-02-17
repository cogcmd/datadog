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

  def search_metrics(query)
    status, json = client.search(query)
    json["results"]["metrics"].map { |metric| { name: metric } }
  end

  def show_graph(query, from, to)
    status, json = client.graph_snapshot(query, from, to)
    sleep 2 # give datadog some time to generate the image
    [json]
  end
end
