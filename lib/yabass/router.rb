require 'yabass/page'

module Yabass
  module Router
    attr_reader :pages, :data
    def initialize(*args, &block)
      load_route_data
      init_routes
      super()
    end

    private 
      def load_route_data
        file_extensions = %w|yml rb|
        file_extensions.each do |ext|
          file_path = File.expand_path("data/index.#{ext}", root_path)
          if File.exist?(file_path)
            case ext
            when 'yml'
              @data = YAML.load(ERB.new(File.read(file_path)).result)
              break
            when 'rb'
              clean_room = Object.new
              @data = clean_room.instance_eval(File.read(file_path))
              break
            end
          end
        end
      end

      def init_routes
        console.error('Data is not loaded') if @data.nil?
        @pages = []
        class << @pages
          def routes; self.map(&:route); end
          def file_paths; self.map(&:file_path); end
          def data; self.map(&:data); end
        end
        @data.each do |k, v|
          set_index_route({k => v})
        end
      end

      def set_index_route(model, prev_route = '', parents = '')
        model_name = model.keys.first
        list = model.values.first
        parents = "#{parents}/#{model_name}"
        file_path = File.expand_path("views#{parents}/index.erb", root_path)
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
        file_path = File.expand_path("views#{parents}/show.erb", root_path)
        new_route = "#{prev_route}/#{key}"
        page = Page.new(new_route, file_path, element)
        @pages.push(page)
        element.each do |k, v|
          if v.kind_of?(Array) && v.first['id']
            set_index_route({k => v}, new_route, parents)
          end
        end
      end
  end
end

