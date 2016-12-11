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
          found_page = pages.find{|page| /^#{page.route}\/?$/ =~ req.path }
          file_path = File.expand_path("public/#{req.path}", ::Yabass::root)
          if found_page
            res.body = Renderer.render(found_page.file_path, found_page.data, found_page.parent)
            res.content_type = 'text/html'
            res.status = 200
          elsif File.file?(file_path)
            res.body = File.read(file_path)
            mime = WEBrick::HTTPUtils.mime_type(file_path, WEBrick::HTTPUtils::DefaultMimeTypes)
            res.content_type = mime
            res.status = 200
          else
            res.body = "Path: #{req.path}\nNot found"
            res.content_type = 'text/plain'
            res.status = 404
          end
        end
        trap("INT"){ server.shutdown }
        server.start
      end
    end
  end
end

