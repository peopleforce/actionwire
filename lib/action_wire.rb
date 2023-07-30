# frozen_string_literal: true

require "action_view"
require "active_support/dependencies/autoload"

require_relative "action_wire/engine"
require_relative "action_wire/component"

module ActionWire
  class Error < StandardError; end
end
