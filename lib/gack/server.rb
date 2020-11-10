# frozen_string_literal: false

require 'socket'

module Gack
  # The main TCP server
  class Server
    attr_reader :tcp, :port, :logger

    def initialize(tcp: TCPServer, port: 6565, logger: Gack::Logger)
      @tcp = tcp
      @port = port
      @logger = logger
    end

    def event_loop(&blk)
      logger.info("starting. port=#{port}")

      server = tcp.new(port)

      loop do
        Thread.new(server.accept) do |client|
          main_handler(client, &blk)
        end
      end
    rescue StandardError => e
      logger.error(e)
    end

    def main_handler(client, &blk)
      unrescued_handler(client, &blk)
    rescue StandardError => e
      logger.error(e)

      failure_response.finalize
    end

    def unrescued_handler(client, &blk)
      raw_request = receive_request(client)

      request = Request.new(raw_request)

      logger.info("request received: #{request.location}")

      response = blk.call(request)

      logger.info("response: #{response.status_code}")

      client.puts(response.finalize)
      client.close
    end

    def failure_response
      Response.new(Response::StatusCodes::TEMPORARY_FAILURE, 'Server Error')
    end

    private

    def receive_request(client)
      request = ''
      begin
        client.read_nonblock(2056, request)
      rescue IO::WaitReadable
        IO.select([client])
        retry
      end
      request
    end
  end
end
