module Yabass
  module Assets
    class Asset
      attr_accessor :route, :file_path
      def initialize(route, file_path)
        @route = route
        @file_paht = file_path
      end

      def to_h
        {
          route: @route,
          file_path: @file_path
        }
      end
    end
  end
end

