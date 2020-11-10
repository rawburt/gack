# frozen_string_literal: true

module Gack
  class Response
    # Gemini Response Status Codes
    class StatusCodes
      # Inputs. <META> = prompt text
      INPUT = 10
      SENSITIVE_INPUT = 11

      # Success. <META> = MIME. <BODY>
      SUCCESS = 20

      # Redirect. <META> = URL
      REDIRECT_TEMPORARY = 30
      REDIRECT_PERMANANT = 31

      # Temporary Failure. <META> = additional information
      TEMPORARY_FAILURE = 40
      SERVER_UNAVAILABLE = 41
      CGI_ERROR = 42
      PROXY_ERROR = 43
      SLOW_DOWN = 44

      # Permanent Failure. <META> = additional information
      PERMANENT_FAILURE = 50
      NOT_FOUND = 51
      GONE = 52
      PROXY_REQUEST_REFUSED = 53
      BAD_REQUEST = 59

      # Client Certificate Requires. <META> = additional information
      CLIENT_CERTIFICATE_REQUIRED = 60
      CERTIFICATE_NOT_AUTHORIZED = 61
      CERTIFICATE_NOT_VALID = 62

      VALID_CODES = [
        INPUT,
        SENSITIVE_INPUT,
        SUCCESS,
        REDIRECT_TEMPORARY,
        REDIRECT_PERMANANT,
        TEMPORARY_FAILURE,
        SERVER_UNAVAILABLE,
        CGI_ERROR,
        PROXY_ERROR,
        SLOW_DOWN,
        PERMANENT_FAILURE,
        NOT_FOUND,
        GONE,
        PROXY_REQUEST_REFUSED,
        BAD_REQUEST,
        CLIENT_CERTIFICATE_REQUIRED,
        CERTIFICATE_NOT_AUTHORIZED,
        CERTIFICATE_NOT_VALID
      ].freeze
    end
  end
end
