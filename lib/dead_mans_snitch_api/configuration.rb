# frozen_string_literal: true

require "dry-configurable"

class DeadMansSnitchApi
  class Configuration
    extend Dry::Configurable
    setting :api_key
  end
end
