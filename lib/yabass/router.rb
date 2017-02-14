require 'yabass/page'

module Yabass
  class Router
    attr_reader :data

    def initialize
      start
    end

    def start
      load_route_data
      init_routes
    end

    alias reload start

    def pages
      if File.mtime(@data_path) > @last_mtime
        logger.info('Data was updated') 
        reload
      end
      @pages
    end

    private 
      def logger
          @logger ||= Logger.new(STDOUT)
      end

      def load_route_data
        file_extensions = %w|yml rb|
        file_extensions.each do |ext|
          @data_path = File.expand_path("data/index.#{ext}", ::Yabass::root)
          if File.exist?(@data_path)
            case ext
            when 'yml'
              @data = YAML.load(ERB.new(File.read(@data_path)).result)
              break
            when 'rb'
              clean_room = Object.new
              @data = clean_room.instance_eval(File.read(@data_path), @data_path)
              break
            end
          end
        end
        @last_mtime = File.mtime(@data_path)
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
          logger.error('Data is not loaded') 
        end
      end

      def set_index_route(model, parent_element, prev_route = '', parents = '')
        model_name = model.keys.first
        list = model.values.first
        parents = "#{parents}/#{model_name}"
        view_path = File.expand_path("views#{parents}/index.erb", ::Yabass::root)
        hidden = model_name.start_with?('_') 

        unless hidden
          if File.exist?(view_path)
            new_route = "#{prev_route}/#{model_name}"
            page = Page.new(new_route, view_path, list, parent_element)
            @pages.push(page)
          else
            logger.warn("Index view file for '#{parents}' => #{view_path} was not found")
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
        view_path = File.expand_path("views#{parents}/show.erb", ::Yabass::root)
        new_route = "#{prev_route}/#{key}"
        page = Page.new(new_route, view_path, element, parent_element)
        @pages.push(page)
        element.each do |k, v|
          if v.kind_of?(Array) && v.first['id']
            set_index_route({k => v}, element, new_route, parents)
          end
        end
      end
  end
end

