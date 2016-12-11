require 'sass'

module Yabass
  module Assets
    module Converter
      class << self
        def convert(full_file_path)
          case full_file_path
          when ext(%w|scss sass|)
            convert_sass(full_file_path)
          when ext(%w|js es es6|)
            convert_js(full_file_path)
          end
        end

        def convert_sass(full_file_path)
          Sass.compile_file(full_file_path)
        end

        def convert_js(full_file_path)
        end

        private
          # Generate regexp for matching extensions
          def ext(extensions)
            /\.(#{extensions.join('|')})$/i # ['js', 'es6'] => /\.(js|es6)$/i
          end
      end
    end
  end
end

