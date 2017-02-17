require 'cog/command'
require 'datadog'
require 'datadog/client'

class Datadog::Command < Cog::Command
  def client
    require_api_key!
    require_application_key!
    @client ||= Datadog::Client.new(api_key, application_key)
  end

  def api_key
    ENV['DATADOG_API_KEY']
  end

  def application_key
    ENV['DATADOG_APPLICATION_KEY']
  end

  def require_api_key!
    unless api_key
      raise(Cog::Abort, "`DATADOG_API_KEY` not set.")
    end
  end

  def require_application_key!
    unless application_key
      raise(Cog::Abort, "`DATADOG_APPLICATION_KEY` not set.")
    end
  end
end
