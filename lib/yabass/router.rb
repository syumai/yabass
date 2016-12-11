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
        @pages = []
        class << @pages
          def routes; self.map(&:route); end
          def file_paths; self.map(&:file_path); end
          def data; self.map(&:data); end
          def parents; self.map(&:parent); end
        end
        if @data
          @data.each do |k, v|
            set_index_route({k => v}, @data)
          end
        else
          console.error('Data is not loaded') 
        end
      end

      def set_index_route(model, parent_element, prev_route = '', parents = '')
        model_name = model.keys.first
        list = model.values.first
        parents = "#{parents}/#{model_name}"
        view_path = File.expand_path("views#{parents}/index.erb", root_path)
        hidden = model_name.start_with?('_') 

        unless hidden
          if File.exist?(view_path)
            new_route = "#{prev_route}/#{model_name}"
            page = Page.new(new_route, view_path, list, parent_element)
            @pages.push(page)
          else
            console.warn("Index view file for '#{parents}' => #{view_path} was not found")
          end
        end

        if list.kind_of?(Array)
          list.each do |element|
            set_element_route(element, parent_element, new_route || prev_route, parents)
          end
        end
      end

      def set_element_route(element, parent_element, prev_route, parents)
        key = element['key'] || element['id']
        file_path = File.expand_path("views#{parents}/show.erb", root_path)
        new_route = "#{prev_route}/#{key}"
        page = Page.new(new_route, file_path, element, parent_element)
        @pages.push(page)
        element.each do |k, v|
          if v.kind_of?(Array) && v.first['id']
            set_index_route({k => v}, element, new_route, parents)
          end
        end
      end
  end
end

