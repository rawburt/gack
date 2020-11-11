# frozen_string_literal: true

module Gack
  # Parse a Gemini request into a friendly object
  class Request
    PROTOCOL = 'gemini://'

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def location
      @location ||= parse_location
    end

    def input
      @input ||= parse_input
    end

    private

    def parse_location
      # ignore input
      location_only = clean_request.split('?').first

      return unless location_only

      split_request = location_only.split('/')

      return '/' if split_request.size == 1

      return "/#{split_request.last}" if split_request.size == 2

      "/#{split_request[1..].join('/')}"
    end

    def parse_input
      split_input = clean_request.split('?')

      if split_input.size > 2
        CGI.unescape(split_input[1..].join('?'))
      else
        CGI.unescape(split_input.last)
      end
    end

    # `.chomp` to drop the trailing \r\n and `.gsub` to remove the protocol
    def clean_request
      @clean_request ||= request.chomp.gsub(PROTOCOL, '')
    end
  end
end
