require 'webrick'

module Yabass
  module Server
    class << self
      def start(pages)
        server = WEBrick::HTTPServer.new({ DocumentRoot: './',
                                           BindAddress: '127.0.0.1',
                                           Port: 3030})
        server.mount_proc('/') do |req, res|
          p req.path
          page = pages.routes.find{|p| p.route == req.path }
          if page
            res.body = render(page.data, page.file_path)
          else
            res.body = "Path: #{req.path} \n Not found"
          end
        end
        trap("INT"){ server.shutdown }
        server.start
      end
    end
  end
end

