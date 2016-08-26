require 'yaml'
require 'erb'
require 'find'

module Yabass
  class Yabass
    def initialize(root_path)
      @root_path = root_path
      file_path = File.expand_path('data/index.yml', root_path)
      @data = YAML.load(File.read(file_path))
    end

    def generate
      raise 'Data is not loaded' if @data.nil?
      @data.each do |key, value|
        if key === 'pages'
          value.each do |model|
            model.each do |path, ary|
              ary.each do |data|
                file = render(data, path)
                output(file, "#{path}/#{data['id']}")
              end
              if File.exist?(File.expand_path("views/#{path}/index.erb", @root_path))
                file = render(ary, path, 'index')
                output(file, path)
              end
            end
          end
        end
      end
    end

    private
      def output(file, path, file_name = 'index')
        file_path = File.expand_path("public/#{path}/#{file_name}.html", @root_path)
        generate_missing_dir(file_path)
        File.open(file_path, 'w') do |f|
          f.print file
        end
      end

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
          expanded_path = File.expand_path(dir, @root_path)
          Dir.mkdir(expanded_path) unless Dir.exist?(expanded_path)
        end
      end

      def render(data, path, view_name = 'show', layout = '_layout.erb')
        view_path = "views/#{path}/#{view_name}.erb"
        view_file = File.expand_path(view_path, @root_path)
        view_erb = ERB.new(File.read(view_file))
        page = view_erb.result(binding)
        render_layout(page)
      end

      def render_layout(page)
        layout_path = 'views/_layout.erb'
        layout_file = File.expand_path(layout_path, @root_path)
        layout_erb = ERB.new(File.read(layout_file))
        layout_erb.result(binding)
      end
  end
end
