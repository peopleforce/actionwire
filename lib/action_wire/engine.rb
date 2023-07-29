require_relative "version"

module ActionWire
  def self.config
    Rails.application.config.action_wire
  end

  class Engine < ::Rails::Engine
    #isolate_namespace ActionWire


  end
end