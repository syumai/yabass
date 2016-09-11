require 'yaml'
require 'erb'
require 'logger'
require_relative './yabass/version'

$LOAD_PATH << "#{File.dirname(__FILE__)}"

module Yabass
  autoload :Router, 'yabass/router'
  autoload :Generator, 'yabass/generator'
  autoload :Server, 'yabass/server'

  class << self
    attr_accessor :root
  end

  class Yabass
    attr_reader :console, :root_path

    include Router

    def initialize(root_path)
      @console = Logger.new(STDOUT)
      ::Yabass::root = root_path
      super
    end

    def routes
      puts pages.routes
    end

    def generate
      Generator.generate(pages)
    end

    def server
      Server.start(pages)
    end
  end
end
