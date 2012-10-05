module ApplicationHelper

  def light_format(string)
    return "" unless string.present?
    string = simple_format h(string)
    auto_link string
  end

  def url_with_params(style, h)
    url = URI.parse(request.url)
    unless h.empty?
      params = Rack::Utils.parse_query(url.query)
      params.update h
      url.query = params.to_param
    end
    case style
    when :URI
      return url.path + '?' + url.query
    when :URL
      return url.to_s
    else
      return url.to_s
    end
  end

  def bound_value (value, range)
    return range.first if value < range.first
    return range.last if value > range.last
    value
  end

  def closest_value value, list
    return list.min { |a,b| (a-value).abs <=> (b-value).abs }
  end

  MINUTE = 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24
  WEEK = DAY * 7
  def duration_abbrev(seconds)

      (weeks, seconds) = seconds.divmod WEEK
      (days, seconds) = seconds.divmod DAY
      (hours, seconds) = seconds.divmod HOUR
      (minutes, seconds) = seconds.divmod MINUTE
      seconds = seconds.floor

       clauses = [
           ("#{weeks}w" if weeks > 0),
           ("#{days}d" if days > 0),
           ("#{hours}h" if hours > 0),
           ("#{minutes}m" if minutes > 0),
           ("#{seconds}s" if seconds > 0)
       ]
       clauses.join('')
  end

  def relative_time(start_time)
    diff_seconds = Time.now - start_time
    case diff_seconds
    when 0 .. 59
      "#{diff_seconds} seconds ago"
    when 60 .. (3600-1)
      minutes = (diff_seconds/60).round
      "#{minutes} minutes ago"
    when 3600 .. (3600*24-1)
      hours = (diff_seconds/3600).round
      "#{hours} hours ago"
    when (3600*24) .. (3600*24*30) 
      days = (diff_seconds/(3600*24)).round
      "#{days} days ago"
    else
      start_time.strftime("%m/%d/%Y")
    end
  end

end

