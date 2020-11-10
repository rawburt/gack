# frozen_string_literal: true

RSpec.describe Gack::Application do
  subject(:application) { described_class }

  it 'stores routes' do
    klass = Class.new(Gack::Application) do
      route('/') { 'hello' }
    end

    expect(klass.routes.size).to be(1)
  end

  describe 'match_route' do
    let(:route) { Gack::Route.new('/blog/1') { 'ok' } }

    it 'returns route that meets matching path' do
      expect(application.new([route]).match_route('/blog/1')).to eql(route)
    end

    it 'returns no route if there is no match' do
      expect(application.new([route]).match_route('/blogs')).to be_nil
    end
  end

  describe 'server_loop_handler' do
    let(:route_ok) { Gack::Route.new('/') { 'ok' } }

    let(:route_input) do
      Gack::Route.new('/get_input') do
        Gack::Response.new(Gack::Response::StatusCodes::INPUT, 'ur name plz')
      end
    end

    let(:routes) do
      [route_ok, route_input]
    end

    let(:klass) do
      application.new(routes)
    end

    it 'returns route result as success' do
      resp = klass.server_loop_handler(Gack::Request.new('gemini://localhost/'))

      expect(resp.status_code).to be(20)
      expect(resp.body).to eql('ok')
    end

    it 'returns routes gack response' do
      resp = klass.server_loop_handler(Gack::Request.new('gemini://localhost/get_input'))

      expect(resp.status_code).to be(10)
      expect(resp.meta).to eql('ur name plz')
    end

    it 'returns not found if no match' do
      resp = klass.server_loop_handler(Gack::Request.new('gemini://localhost/b0rk3d'))

      expect(resp.status_code).to be(51)
    end
  end

  describe 'run!' do
    it 'accepts a port' do
      mock_server = class_double(Gack::Server)
      mock_server_instance = instance_double(Gack::Server)

      allow(mock_server_instance).to receive(:event_loop)
      allow(mock_server).to receive(:new).with(port: 1234).and_return(mock_server_instance)

      described_class.run!(port: 1234, server: mock_server)
    end
  end
end
