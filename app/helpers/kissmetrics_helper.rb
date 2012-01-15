module KissmetricsHelper
  def km_record(event, options = nil)
    flash[:kissmetrics] ||= []
    if options
      flash[:kissmetrics] += [[event, options]]
    else
      flash[:kissmetrics] += [event]
    end
  end

  def km_events
    (flash[:kissmetrics] || []).map do |event|
      if event.is_a?(Array)
        name, options = event
        "_kmq.push(['record', '#{escape_javascript name}', #{options.to_json}]);"
      else
        "_kmq.push(['record', '#{escape_javascript event}']);"
      end

    end.join("\n")
  end
end
