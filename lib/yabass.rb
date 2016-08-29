require 'yaml'
require 'erb'
require 'logger'

module Yabass
  class Yabass
    attr_reader :routes, :console

    def initialize(root_path)
      @console = Logger.new(STDOUT)
      @root_path = root_path
      file_path = File.expand_path('data/index.yml', root_path)
      @data = YAML.load(ERB.new(File.read(file_path)).result)
      init_routes
    end

    def print_routes
      puts @routes.routes
    end

    def generate
      @routes.each do |info|
        file_path = info[:file_path]
        data = info[:data]
        route = info[:route]
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
        @routes = []
        class << @routes
          def routes; self.map{|h| h[:route]}; end
          def file_paths; self.map{|h| h[:file_path]}; end
          def data; self.map{|h| h[:data]}; end
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
          route_info = {
            route: new_route,
            file_path: file_path,
            data: list
          }
          @routes.push(route_info)
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
        route_info = {
          route: new_route,
          file_path: file_path,
          data: element
        }
        @routes.push(route_info)
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
