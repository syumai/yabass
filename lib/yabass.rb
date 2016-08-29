require 'yaml'
require 'erb'
require 'logger'

$LOAD_PATH << "#{File.dirname(__FILE__)}"

module Yabass
  autoload :Page, 'yabass/page'
  autoload :Server, 'yabass/server'

  class Yabass
    attr_reader :console

    include 'yabass/router'

    def initialize(root_path)
      @console = Logger.new(STDOUT)
      @root_path = root_path
      file_path = File.expand_path('data/index.yml', root_path)
      @data = YAML.load(File.read(file_path))
      init_routes
      super
    end

    def server
      Yabass::Server.start(@pages)
    end

    def routes
      puts @pages.routes
    end

    def generate
      @pages.each do |page|
        file_path = page.file_path
        data = page.data
        route = page.route
        output_path = File.expand_path("public/#{route}/index.html", @root_path)
        file = render(data, file_path)
        generate_missing_dir(output_path)
        File.open(output_path, 'w') do |f|
          f.print file
        end
      end
    end

    private
      def init_routes
        console.error('Data is not loaded') if @data.nil?
        @pages = []
        class << @pages
          def routes; self.map(&:route); end
          def file_paths; self.map(&:file_path); end
          def data; self.map(&:data); end
        end
        @data['pages'].each do |model|
          set_index_route(model)
        end
      end

      def set_index_route(model, prev_route = '', parents = '')
        model_name = model.keys.first
        list = model.values.first
        parents = "#{parents}/#{model_name}"
        file_path = File.expand_path("views#{parents}/index.erb", @root_path)
        file_exists = File.exist?(file_path)
        hidden = /^_/ =~ model_name
        console.warn("Index view file for '#{parents}' => #{file_path} was not found") if !hidden && !file_exists
        if !hidden && file_exists
          new_route = "#{prev_route}/#{model_name}"
          page = Page.new(new_route, file_path, list)
          @pages.push(page)
        end
        if list.kind_of?(Array)
          list.each do |element|
            set_element_route(element, new_route || prev_route, parents)
          end
        end
      end

      def set_element_route(element, prev_route, parents)
        key = element['key'] || element['id']
        file_path = File.expand_path("views#{parents}/show.erb", @root_path)
        new_route = "#{prev_route}/#{key}"
        page = Page.new(new_route, file_path)
        @pages.push(page)
        element.each do |k, v|
          if v.kind_of?(Array) && v.first['id']
            set_index_route({k => v}, new_route, parents)
          end
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

      def render(data, file_path, layout = '_layout.erb')
        view_erb = ERB.new(File.read(file_path))
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
