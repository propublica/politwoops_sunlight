module ApplicationHelper

  def light_format(string)
    return "" unless string.present?
    string = simple_format h(string)
    auto_link string
  end

end