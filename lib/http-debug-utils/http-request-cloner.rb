require 'http-debug-utils'
require 'kage'

class HttpDebugUtils
  module HttpRequestCloner
    def self.run
      options = {}

      parser = HttpDebugUtils.option_parser
      parser.on("-p", "--port PORT", "Port to listen") {|port| options["port"] = port.to_i }
      parser.on("--backend-port PORT", "Port which is listened by master backend application") {|port| options["backend-port"] = port.to_i }
      parser.on("--slave-backend-port PORT", "Port which is listened by slave backend application") {|port| options["slave-backend-port"] = port.to_i }
      parser.parse!(ARGV)

      Kage::ProxyServer.start do |server|
        server.port = (options["port"] or raise("Need option -p=PORT"))
        server.host = '0.0.0.0'
        server.debug = false

        server.add_master_backend(:master, 'localhost', options["backend-port"])
        server.add_backend(:slave, 'localhost', options["slave-backend-port"])

        server.on_select_backends do |request, headers|
          # FIXME configurable
          is_asset = request[:path] =~ /\.(ico|js|css|gif|png|jpe?g)$/
          is_asset ? [:master] : [:master, :slave]
        end

        puts "Server is listening 0.0.0.0:#{server.port}"
      end
    end
  end
end
