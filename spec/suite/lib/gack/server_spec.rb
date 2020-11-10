# frozen_string_literal: true

RSpec.describe Gack::Server do
  subject(:server) { described_class }

  let(:success_response) do
    Gack::Response.new(Gack::Response::StatusCodes::SUCCESS, Gack::Response::MIME[:text], 'okiedokie')
  end

  let(:mock_logger) { MockLogger.new }

  let(:logged_server) { server.new(logger: mock_logger) }

  let(:mock_request_io) { instance_double(IO) }

  describe 'unrescued_handler' do
    it 'returns response' do
      allow(mock_request_io).to receive(:read_nonblock).and_return('')
      allow(mock_request_io).to receive(:puts).with(success_response.finalize)
      allow(mock_request_io).to receive(:close)

      logged_server.unrescued_handler(mock_request_io) do
        success_response
      end
    end
  end

  describe 'main_handler' do
    it 'rescues errors' do
      allow(mock_request_io).to receive(:read_nonblock).and_return('')
      allow(mock_request_io).to receive(:puts).with(logged_server.failure_response.finalize)
      allow(mock_request_io).to receive(:close)

      logged_server.main_handler(mock_request_io) do
        raise 'oopsies'
      end

      expect(mock_logger.logs.find { |log| log.first == :error }).not_to be_nil
    end
  end
end
