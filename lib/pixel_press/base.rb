module PixelPress
  class Base < ActionController::Base
    def self.template(name, options = {}, &block)
      define_method name do |*args|
        instance_exec(*args, &block)
        filename = instance_eval(&options[:filename]) if options[:filename].respond_to?(:call)
        html = render_to_string "#{controller_path}/#{__method__}.pdf", formats: [:html]
        pdf = WeasyPrint.new(html).to_pdf
        stream = PixelPress::StreamablePDF.new(pdf)
        stream.original_filename = filename || "document.pdf"
        stream.content_type = "application/pdf"
        stream
      end

      define_singleton_method name do |*args|
        new.send(name, *args)
      end
    end
  end
end
