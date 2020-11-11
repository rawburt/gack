# frozen_string_literal: true

module Gack
  # The main DSL for making Gemini apps with Gack
  class Application
    def self.route(path, &handler)
      routes << Gack::Route.new(path, &handler)
    end

    def self.routes
      @routes ||= []
    end

    def self.run!
      new(routes).run!
    end

    attr_reader :routes

    def initialize(routes)
      @routes = routes
    end

    def run!
      server = Gack::Server.new
      server.event_loop do |request|
        server_loop_handler(request)
      end
    end

    def server_loop_handler(request)
      route = match_route(request.location)
      if route
        result = route.handle_request(request)
        if result.is_a?(Response)
          result
        else
          Response.new(Response::StatusCodes::SUCCESS, Response::MIME[:text], result)
        end
      else
        Response.new(Response::StatusCodes::NOT_FOUND)
      end
    end

    def match_route(location)
      routes.find { |s| s.path_match?(location) }
    end
  end
end
