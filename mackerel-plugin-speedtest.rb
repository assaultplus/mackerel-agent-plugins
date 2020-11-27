def mackerel_plugin_speedtest(server_id)
  require "json"
  require "time"

  name = ["ping.jitter","ping.latency","packetLoss","bandwidth.download", "bandwidth.upload"]
  metric_prefix = "speedtest."

  # execute speedtest
  begin
    hash = JSON.parse(%x(speedtest "--format=json" "--server-id=#{server_id}"))
  
    # metric value
    value = hash["ping"]["jitter"],hash["ping"]["latency"],hash["packetLoss"],hash["download"]["bandwidth"],hash["upload"]["bandwidth"]

    # ISO8601 => UnixTime
    epoch_seconds = Time.iso8601(hash["timestamp"]).getlocal.to_i
 
  rescue => exception  
    # value <= nil
    value = [nil]

    # epoch_seconds <= current time
    epoch_seconds = Time.now.getlocal.to_i

  end

  # output custom metric format
  name.zip(value){|metric_name, metric_value|
    print "#{metric_prefix}#{metric_name}\t#{metric_value}\t#{epoch_seconds}\n"

  }

end

mackerel_plugin_speedtest 7139