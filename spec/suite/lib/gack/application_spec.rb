# frozen_string_literal: true

RSpec.describe Gack::Application do
  subject(:application) { described_class }

  it 'stores spheres' do
    klass = Class.new(Gack::Application) do
      sphere('/') { 'hello' }
    end

    expect(klass.spheres.size).to be(1)
  end

  describe 'match_sphere' do
    let(:sphere) { Gack::Sphere.new('/blog/1') { 'ok' } }

    it 'returns sphere that meets matching path' do
      expect(application.new([sphere]).match_sphere('/blog/1')).to eql(sphere)
    end

    it 'returns no sphere if there is no match' do
      expect(application.new([sphere]).match_sphere('/blogs')).to be_nil
    end
  end

  describe 'server_loop_handler' do
    let(:sphere_ok) { Gack::Sphere.new('/') { 'ok' } }

    let(:sphere_input) do
      Gack::Sphere.new('/get_input') do
        Gack::Response.new(Gack::Response::StatusCodes::INPUT, 'ur name plz')
      end
    end

    let(:spheres) do
      [sphere_ok, sphere_input]
    end

    let(:klass) do
      application.new(spheres)
    end

    it 'returns sphere result as success' do
      resp = klass.server_loop_handler(Gack::Request.new('gemini://localhost/'))

      expect(resp.status_code).to be(20)
      expect(resp.body).to eql('ok')
    end

    it 'returns spheres gack response' do
      resp = klass.server_loop_handler(Gack::Request.new('gemini://localhost/get_input'))

      expect(resp.status_code).to be(10)
      expect(resp.meta).to eql('ur name plz')
    end

    it 'returns not found if no match' do
      resp = klass.server_loop_handler(Gack::Request.new('gemini://localhost/b0rk3d'))

      expect(resp.status_code).to be(51)
    end
  end
end
