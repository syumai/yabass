require 'webrick'
require 'webrick/httpstatus'
require 'yabass/renderer'

module Yabass
  module Server
    class << self
      def start(router, options = {})
        port = options.has_key?(:port) ? options[:port] : 3030
        server = WEBrick::HTTPServer.new({ DocumentRoot: './',
                                           BindAddress: '127.0.0.1',
                                           Port: port})
        server.mount_proc('/') do |req, res|
          found_page = router.pages.find{|page| /^#{page.route}\/?$/ =~ req.path }
          file_path = File.expand_path("public/#{req.path}", ::Yabass::root)
          index_path = "#{file_path}/index.html"
          if found_page
            if directory_path?(req.path)
              res.body = Renderer.render(found_page.file_path, found_page.data, found_page.parent)
              res.content_type = 'text/html'
              res.status = 200
            else # Redirect to directory path
              res['Pragma'] = 'no-cache'
              res.set_redirect(WEBrick::HTTPStatus::MovedPermanently, "#{found_page.route}/")
            end
          elsif File.file?(file_path)
            res.body = File.read(file_path)
            mime = WEBrick::HTTPUtils.mime_type(file_path, WEBrick::HTTPUtils::DefaultMimeTypes)
            res.content_type = mime
            res.status = 200
          elsif File.directory?(file_path) && File.file?(index_path)
            if directory_path?(req.path)
              res.body = File.read(index_path)
              res.content_type = 'text/html'
              res.status = 200
            else
              res['Pragma'] = 'no-cache'
              res.set_redirect(WEBrick::HTTPStatus::MovedPermanently, "#{req.path}/")
            end
          else
            res.body = "Path: #{req.path}\nNot found"
            res.content_type = 'text/plain'
            res.status = 404
          end
        end
        trap("INT"){ server.shutdown }
        server.start
      end
      private
        def directory_path?(path)
          /.\/$/ =~ path
        end
    end
  end
end

