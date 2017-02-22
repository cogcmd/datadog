require 'datadog/command'
require 'active_support/all'

module CogCmd::Datadog
  class Graph < Datadog::Command
    TIME_UNITS = {'d' => :days, 'h' => :hours, 'm' => :minutes, 's' => :seconds}
    EARLIEST_START_TIME = 1262322000

    def run_command
      parse_start_time!
      parse_end_time!

      response.content = client.show_graph(query, start_time, end_time)
      response.template = 'graph'
    end

    def query
      request.args.last
    end

    def start_time
      @start_time || Time.now - 1.hour
    end

    def end_time
      @end_time || Time.now
    end

    def parse_start_time!
      return unless unparsed_start_time

      @start_time = relative_start_time(unparsed_start_time) ||
        unix_timestamp(unparsed_start_time)

      unless @start_time
        raise(Cog::Abort, 'Failed to parse start time. Start time must be a shorthand negative amount relative to the current time (-1h, -30m, -60s) or a unix timestamp (1487784016).')
      end
    end

    def parse_end_time!
      return unless unparsed_end_time

      @end_time = relative_end_time(unparsed_end_time) ||
        unix_timestamp(unparsed_end_time) ||
        now(unparsed_end_time)

      unless @end_time
        raise(Cog::Abort, 'Failed to parse end time. End time must be a shorthand positive amount relative to the start time (1h, 30m, 60s), a unix timestamp (1487784076), or "now" for the current time.')
      end
    end

    def unparsed_start_time
      return unless request.args.size > 1
      request.args[0]
    end

    def unparsed_end_time
      return unless request.args.size > 2
      request.args[1]
    end

    def relative_start_time(time)
      return false if time[0] != '-'

      amount = time[1..-2].to_i
      return false if amount == 0

      unit = TIME_UNITS[time[-1]]
      return false unless unit

      return Time.now - amount.public_send(unit)
    end

    def relative_end_time(time)
      amount = time[0..-2].to_i
      return false if amount == 0

      unit = TIME_UNITS[time[-1]]
      return false unless unit

      return @start_time + amount.public_send(unit)
    end

    def unix_timestamp(time)
      seconds = time.to_i
      return false if seconds < EARLIEST_START_TIME

      return Time.at(seconds)
    end

    def now(time)
      time == "now" && Time.now
    end
  end
end
