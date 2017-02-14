module Yabass
  module Renderer
    class << self
      def render(full_file_path, data = nil, parent = nil, layout = '_layout.erb')
        view_erb = ERB.new(File.read(full_file_path))
        view_erb.filename = full_file_path
        page = view_erb.result(binding)
        render_layout(page)
      end

      def render_partial(file_path, **args)
        full_file_path = File.expand_path("views/#{file_path}", ::Yabass::root)
        view_erb = ERB.new(File.read(full_file_path))
        view_erb.filename = full_file_path
        _binding = binding
        args.each {|k, v| _binding.local_variable_set(k, v) } unless args.empty?
        view_erb.result(_binding)
      end

      def render_layout(page)
        full_layout_path = File.expand_path("views/_layout.erb", ::Yabass::root)
        layout_erb = ERB.new(File.read(full_layout_path))
        layout_erb.filename = full_layout_path
        layout_erb.result(binding)
      end
    end
  end
end

