# frozen_string_literal: true

RSpec.describe Gack::Response do
  subject(:response) { described_class }

  it 'requires a valid status code' do
    expect do
      response.new(123)
    end.to raise_error(Gack::Response::InvalidStatusCodeError)
  end

  it 'does not allow body for status code that is not success' do
    Gack::Response::StatusCodes::VALID_CODES.each do |status_code|
      next if status_code == Gack::Response::StatusCodes::SUCCESS

      expect do
        response.new(status_code, nil, 'no bodies for input')
      end.to raise_error(Gack::Response::BodyNotAllowedError)
    end
  end

  it 'requires meta of max length 1024 bytes' do
    response.new(10, ('a' * 1024))

    expect do
      response.new(10, ('a' * 1025))
    end.to raise_error(Gack::Response::MetaTooLongError)
  end

  describe 'success response' do
    it 'requires a mime meta' do
      expect do
        response.new(20, nil, 'hey pal!')
      end.to raise_error(Gack::Response::InvalidMimeError)
    end
  end

  describe '#finalize' do
    it 'builds a response' do
      expect(response.new(10).finalize).to eql("10\r\n")
    end

    it 'builds a response with a meta' do
      expect(response.new(30, 'gemini://somewhere').finalize).to eql("30 gemini://somewhere\r\n")
    end

    it 'builds a response with a body' do
      expect(response.new(20, 'text/gemini', 'hello!').finalize).to eql("20 text/gemini\r\nhello!")
    end
  end
end
