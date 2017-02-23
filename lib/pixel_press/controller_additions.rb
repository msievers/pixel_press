module PixelPress
  module ControllerAdditions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def printer(name, options = {}, &block)
        define_method name do
          instance_eval(&block)
          filename = instance_eval(&options[:filename]) if options[:filename].respond_to?(:call)

          respond_to do |format|
            format.html
            format.pdf do
              html = render_to_string "#{controller_path}/#{action_name}.pdf", formats: [:html]
              pdf = WeasyPrint.new(html).to_pdf
              stream = PixelPress::StreamablePDF.new(pdf)
              stream.original_filename = filename || "document.pdf"
              stream.content_type = "application/pdf"
              send_data stream.read, disposition: "inline", type: "application/pdf"
            end
          end
        end
      end
    end
  end
end
