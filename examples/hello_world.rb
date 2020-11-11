# frozen_string_literal: true

require 'gack'

# An example "Hello, World!" application
class App < Gack::Application
  route '/' do
    'Hello, World!'
  end
end

App.run!
