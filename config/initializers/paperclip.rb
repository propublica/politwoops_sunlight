if Rails.configuration.respond_to?("paperclip_defaults")
  Paperclip::Attachment.default_options.merge!(Rails.configuration.paperclip_defaults)
  interpolations = Paperclip::Attachment.default_options.fetch(:interpolations, {})
  interpolations.each do |k, v|
    Paperclip.interpolates k do |attachment, style|
      v
    end
  end
end
