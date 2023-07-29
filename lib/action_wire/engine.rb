require_relative "version"

module ActionWire
  def self.config
    Rails.application.config.action_wire
  end

  class Engine < ::Rails::Engine

  end
end