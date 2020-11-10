# frozen_string_literal: true

require_relative 'response/status_codes'

module Gack
  # Build a Gemini response
  class Response
    InvalidStatusCodeError = Class.new(StandardError)
    BodyNotAllowedError = Class.new(StandardError)
    MetaTooLongError = Class.new(StandardError)
    InvalidMimeError = Class.new(StandardError)

    META_MAX_BYTES = 1024

    MIME = {
      text: 'text/gemini'
    }.freeze

    attr_reader :status_code, :meta, :body

    def initialize(status_code, meta = nil, body = nil)
      @status_code = Integer(status_code)

      raise InvalidStatusCodeError unless StatusCodes::VALID_CODES.include?(@status_code)

      @meta = meta

      raise MetaTooLongError if @meta && @meta.bytesize > META_MAX_BYTES
      raise InvalidMimeError if @status_code == StatusCodes::SUCCESS && @meta.nil?

      @body = body

      raise BodyNotAllowedError if @body && @status_code != StatusCodes::SUCCESS
    end

    def finalize
      return "#{status_code}\r\n" unless meta

      "#{status_code} #{meta}\r\n#{body}"
    end
  end
end
