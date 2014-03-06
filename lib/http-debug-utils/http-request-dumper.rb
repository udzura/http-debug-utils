require 'http-debug-utils'
require 'webrick'
require 'json'

# The monkey patch...
class WEBrick::HTTPServlet::ProcHandler
  alias do_PATCH  do_POST
  alias do_PUT    do_POST
  alias do_DELETE do_POST
end

class HttpDebugUtils
  module HttpRequestDumper
    HORIZON = "\e[31m" + ("#" * 72) + "\e[0m"

    def self.dump_http_request(req)
      puts HORIZON
      puts req.request_line
      puts req.raw_header
      puts
      if body = req.body
        puts body.lines.map{|line| line.gsub /[[:cntrl:]]/, '' }
      else
        puts "\e[35m*** Empty request body (maybe it is GET) ***\e[0m"
      end
      puts HORIZON
      puts
    end

    def self.run
      port = nil
      parser = HttpDebugUtils.option_parser
      parser.on("-p", "--port PORT", "Port to listen") {|_port| port = _port.to_i }
      parser.parse!(ARGV)

      srv = WEBrick::HTTPServer.new(
        :BindAddress => "0.0.0.0",
        :Port => port
      )

      srv.mount_proc "/" do |req, res|
        dump_http_request(req)

        res.content_type = "application/json"
        res.body = {return: "OK"}.to_json
      end

      Signal.trap('INT') { srv.shutdown }
      srv.start
    end
  end
end
