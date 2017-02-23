module PixelPress
  class StreamablePDF < StringIO
    attr_accessor :content_type
    attr_accessor :original_filename
  end
end
