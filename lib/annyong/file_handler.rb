module Annyong

  class FileHandler < Rack::File

    def serving
      content_type = Rack::Mime.mime_type(F.extname(@path), 'text/plain')
      case
      when content_type == "text/csv"
        body = Annyong::CSV.new(@root, @path).body
      when @path[ /[.]tsv$/ ]
        body = Annyong::CSV.new(@root, @path, "\t").body
      else
        body = nil
      end
      body ? respond_with(body) : super
    end

    private 

    def respond_with(body)
      [
        200,
        {
        "Content-Type" => "text/html",
        "Content-Length" => body.size.to_s,
        "X-Cascade" => "pass"
      },
        [body]
      ]
    end
  end

end
