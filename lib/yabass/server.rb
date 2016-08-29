require 'webrick'
require 'yabass/renderer'

module Yabass
  module Server
    class << self
      def start(pages)
        server = WEBrick::HTTPServer.new({ DocumentRoot: './',
                                           BindAddress: '127.0.0.1',
                                           Port: 3030})
        server.mount_proc('/') do |req, res|
          found_page = pages.find{|page| page.route === req.path }
          if found_page
            res.body = Renderer.render(found_page.file_path, found_page.data)
          else
            res.body = "Path: #{req.path}\nNot found"
          end
        end
        trap("INT"){ server.shutdown }
        server.start
      end
    end
  end
end

