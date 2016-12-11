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
    attr_reader :root_path

    def initialize(root_path)
      ::Yabass::root = root_path
      Router.start
    end

    def routes
      puts Router.pages.routes
    end

    def generate
      Generator.generate
    end

    def server
      Server.start
    end
  end
end
