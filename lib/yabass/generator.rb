require 'yabass/renderer'

module Yabass
  module Generator
    class << self
      def generate(pages)
        pages.each do |page|
          file_path = page.file_path
          data = page.data
          parent = page.parent
          route = page.route
          output_path = File.expand_path("public/#{route}/index.html", ::Yabass::root)
          file = Renderer.render(file_path, data, parent)
          generate_missing_dir(output_path)
          File.open(output_path, 'w') do |f|
            f.print file
          end
        end
      end

      private
        def generate_missing_dir(path)
          dirs = path.split('/').inject([]) do |result, dir|
            next result if /\.html$/ =~ dir
            if result.last
              result.push("#{result.last}/#{dir}")
            else
              result.push(dir)
            end
            result
          end

          dirs.each do |dir|
            expanded_path = File.expand_path(dir, ::Yabass::root)
            Dir.mkdir(expanded_path) unless Dir.exist?(expanded_path)
          end
        end
    end
  end
end
