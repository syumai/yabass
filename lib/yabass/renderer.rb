module Yabass
  module Renderer
    class << self
      def render(full_file_path, data = nil, layout = '_layout.erb')
        view_erb = ERB.new(File.read(full_file_path))
        page = view_erb.result(binding)
        render_layout(page)
      end

      def render_partial(file_path, **args)
        full_file_path = File.expand_path("views/#{file_path}", ::Yabass::root)
        view_erb = ERB.new(File.read(full_file_path))
        _binding = binding
        args.each {|k, v| _binding.local_variable_set(k, v) } unless args.empty?
        view_erb.result(_binding)
      end

      def render_layout(page)
        layout_path = 'views/_layout.erb'
        layout_file = File.expand_path(layout_path, ::Yabass::root)
        layout_erb = ERB.new(File.read(layout_file))
        layout_erb.result(binding)
      end
    end
  end
end

