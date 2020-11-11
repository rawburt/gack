# frozen_string_literal: true

RSpec.describe Gack::Route do
  subject(:route) { described_class }

  let(:request) { Gack::Request.new('gemini://localhost/blog') }

  it 'requires a block handler' do
    expect do
      route.new('/')
    end.to raise_error(Gack::Route::HandlerMissingError)
  end

  describe 'path_match?' do
    it 'matches given path' do
      new_route = route.new('/test/path.gmi') {}

      expect(new_route.path_match?('/test/path.gmi')).to be(true)
      expect(new_route.path_match?('/test/path')).to be(false)
    end

    it 'matches regex' do
      new_route = route.new(%r{/blog/\d+}) {}

      expect(new_route.path_match?('/blog/123')).to be(true)
      expect(new_route.path_match?('/blog/apple')).to be(false)
      expect(new_route.path_match?('/blog')).to be(false)
    end
  end

  describe 'handle_request' do
    it 'sends a request to handler' do
      empty_handler = proc {}

      allow(empty_handler).to receive(:call).and_return('ok!')

      route.new('/', &empty_handler).handle_request(request)

      expect(empty_handler).to have_received(:call)
    end

    it 'returns a response' do
      result = route.new('/') { 'ok' }.handle_request(request)

      expect(result).to eql('ok')
    end

    it 'provides request information to handler' do
      result = route.new('/', &:location).handle_request(request)

      expect(result).to eql('/blog')
    end
  end
end
