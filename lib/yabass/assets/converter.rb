require 'sass'

module Yabass
  module Assets
    module Converter
      class << self
        def convert(full_file_path)
          case full_file_path.downcase
          when /sass$|scss$/
            convert_sass(full_file_path)
          when /js$|es$|es6$/
            convert_js(full_file_path)
          end
        end

        def convert_sass(full_file_path)
          Sass.compile_file(full_file_path)
        end

        def convert_js(full_file_path)
        end
      end
    end
  end
end

