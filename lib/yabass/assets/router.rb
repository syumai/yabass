module Yabass
  module Assets
    module Router
      attr_reader :assets, :asset_roots
      def initialize(*args, &block)
        init_asset_roots
        init_assets
        super
      end

      private
        def init_asset_roots
          dir = Dir.open('assets')
          @asset_roots = dir.to_a.select{|name| /^\./ !~ name }
        end

        def init_assets
        end
    end
  end
end

