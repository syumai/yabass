$LOAD_PATH << "#{File.dirname(__FILE__)}"

require 'yaml'
require 'erb'
require 'logger'
require 'yabass/version'

module Yabass
  autoload :Router, 'yabass/router'
  autoload :Generator, 'yabass/generator'
  autoload :Server, 'yabass/server'

  class << self
    attr_accessor :root
  end

  class Yabass
    attr_reader :root_path, :router

    def initialize(root_path)
      ::Yabass::root = root_path
      @router = Router.new
    end

    def routes
      puts router.pages.routes
    end

    def generate
      Generator.generate(router)
    end

    def server(options)
      Server.start(router, options)
    end
  end
end
