# frozen_string_literal: true

module Gack
  # The main DSL for making Gemini apps with Gack
  class Application
    def self.sphere(path, &handler)
      spheres << Gack::Sphere.new(path, &handler)
    end

    def self.spheres
      @spheres ||= []
    end

    def self.run!
      new(spheres).run!
    end

    attr_reader :spheres

    def initialize(spheres)
      @spheres = spheres
    end

    def run!
      server = Gack::Server.new
      server.event_loop do |request|
        server_loop_handler(request)
      end
    end

    def server_loop_handler(request)
      sphere = match_sphere(request.location)
      if sphere
        result = sphere.handle_request(request)
        if result.is_a?(Response)
          result
        else
          Response.new(Response::StatusCodes::SUCCESS, Response::MIME[:text], result)
        end
      else
        Response.new(Response::StatusCodes::NOT_FOUND)
      end
    end

    def match_sphere(location)
      spheres.find { |s| s.path_match?(location) }
    end
  end
end
