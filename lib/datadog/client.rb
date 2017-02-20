require 'net/http'
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

  def show_graph(query, from, to, block_until_image = true)
    status, json = client.graph_snapshot(query, from, to)

    # Wait for the snapshot url to return image data. If we return too quickly
    # here, Slack will unfurl an empty image.
    until Net::HTTP.get(URI.parse(json["snapshot_url"])).length > 179
      sleep 0.5
    end

    [json]
  end
end
