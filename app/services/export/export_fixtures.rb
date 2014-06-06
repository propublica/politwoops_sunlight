module Export
  class ExportFixtures < ServiceBase
    include Virtus.model
    attribute :models
    attribute :export_dir, String

    def call
      FileUtils.mkdir_p export_dir
      models.each do |mdl|
        path = File.join(export_dir, "#{mdl.class.table_name}.yml")
        key_prefix = mdl.class.table_name.singularize
        File.open(path, 'w') do |outf|
          key = "#{key_prefix}_#{mdl.id}"
          outf.write({key => mdl.attributes}.to_yaml)
        end
      end

      success "Exported to #{export_dir}"
    end
  end
end

