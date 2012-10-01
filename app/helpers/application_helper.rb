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

