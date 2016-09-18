module Yabass
  class Page
    attr_accessor :route, :file_path, :data, :parent

    def initialize(route, file_path, data = nil, parent = nil)
      @route = route
      @file_path = file_path
      @data = data
      @parent = parent
    end

    def to_h
      {
        route: @route,
        file_path: @file_path,
        data: @data,
        parent: @parent
      }
    end
  end
end

