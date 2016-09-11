module Yabass
  module Assets
    module Router
      attr_reader :assets
      def initialize(*args, &block)
        init_asset_routes
        super
      end

      private
        def init_asset_routes
        end
    end
  end
end

