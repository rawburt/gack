# frozen_string_literal: true

module Gack
  # Route is a Gemini request handler wrapper for a given path
  class Route
    HandlerMissingError = Class.new(StandardError)

    attr_reader :path, :handler

    def initialize(path, &handler)
      @path = path

      raise HandlerMissingError unless handler

      @handler = handler
    end

    def path_match?(string)
      if path.is_a?(Regexp)
        path.match?(string)
      else
        path.eql?(string)
      end
    end

    def handle_request(request)
      handler.call(request)
    end
  end
end
