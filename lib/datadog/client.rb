require 'datadog'
require 'dogapi'
require 'net/http'

class Datadog::Client
  BOGUS_IMAGE_SIZE = 179

  attr_reader :client

  def initialize(api_key, application_key)
    @client = Dogapi::Client.new(api_key, application_key)
  end

  def search_metrics(query)
    status, json = client.search(query)
    json["results"]["metrics"].map { |metric| { name: metric } }
  end

  def show_graph(query, from, to)
    status, json = client.graph_snapshot(query, from, to)

    # Wait for the snapshot url to return image data. If we return too quickly
    # here, Slack will unfurl an empty image.
    wait_for_image(json["snapshot_url"])

    [json]
  end

  private

  def wait_for_image(url)
    sleep(0.5) while bogus_image?(url)
  end

  def bogus_image?(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    response.length <= BOGUS_IMAGE_SIZE
  end
end
