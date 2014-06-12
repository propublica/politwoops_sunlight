module JavascriptExports
  @@EXPORTS = HashWithIndifferentAccess.new

  def self.export (k, v)
    @@EXPORTS[k] = v
  end

  def self.to_s
    "<script type=\"text/javascript\">var #{Rails.application.class.parent.name} = #{@@EXPORTS.to_json};</script>".html_safe
  end
end
