# frozen_string_literal: true

RSpec.describe Gack::Request do
  subject(:request) { described_class }

  describe 'location' do
    it 'returns / for root location' do
      expect(request.new('gemini://localhost').location).to eql('/')
    end

    it 'does not require a protocol' do
      expect(request.new('localhost').location).to eql('/')
    end

    it 'returns location prefixed with /' do
      expect(request.new('gemini://localhost/blog').location).to eql('/blog')
    end

    it 'returns location with multiple depths' do
      full_request = 'gemini://localhost/blog/2012-12-08/file.gmi'
      expected_location = '/blog/2012-12-08/file.gmi'
      expect(request.new(full_request).location).to eql(expected_location)
    end

    it 'ignores input' do
      expect(request.new('localhost?funinput').location).to eql('/')
      expect(request.new('gemini://localhost/blog?moreinput').location).to eql('/blog')
    end
  end

  describe 'input' do
    it 'returns the input' do
      expect(request.new('localhost?funinput').input).to eql('funinput')
    end

    it 'decodes the input' do
      expect(request.new('gemini://localhost/blog?real%20great%20input').input).to eql('real great input')
    end

    it 'handles multiple inputs' do
      expect(request.new('localhost?funinput?butbroken').input).to eql('funinput?butbroken')
    end
  end
end
