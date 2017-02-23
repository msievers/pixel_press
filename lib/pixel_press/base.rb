module PixelPress
  class Base < ActionController::Base
    def self.template(name, options = {}, &block)
      # define an instance method for this template
      define_method name do |*args|
        instance_exec(*args, &block)
        html = render_to_string "#{controller_path}/#{__method__}.pdf", formats: [:html]
        pdf = WeasyPrint.new(html).to_pdf
        stream = PixelPress::StreamablePDF.new(pdf)
        stream.original_filename = "document.pdf"
        stream.content_type = "application/pdf"
        stream
      end

      # make it also accessible as a class method
      define_singleton_method name do |*args|
        new.send(name, *args)
      end
    end
  end
end
