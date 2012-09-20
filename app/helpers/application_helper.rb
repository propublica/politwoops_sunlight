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

end

