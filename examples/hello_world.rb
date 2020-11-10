# frozen_string_literal: true

require 'gack'

# An example "Hello, World!" application
class App < Gack::Capsule
  sphere '/' do
    'Hello, World!'
  end
end

App.run!
