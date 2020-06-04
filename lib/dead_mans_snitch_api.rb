# frozen_string_literal: true

require "rest-client"
require "addressable/uri"
require "addressable/template"
require "dry-configurable"
require "json"
require "dry-configurable"

class DeadMansSnitchApi
  class RequestError < StandardError; end
  extend Dry::Configurable
  GEM_VERSION = "0.1.0"

  autoload :Api, "dead_mans_snitch_api/api"
  autoload :Snitch, "dead_mans_snitch_api/snitch"

  setting :api_key

  def self.all_snitches(tags: [])
    DeadMansSnitchApi::Api.new.all_snitches(tags)
  end

  def self.get(token:)
    DeadMansSnitchApi::Api.new.get(token)
  end

  def self.create(attributes: {})
    DeadMansSnitchApi::Api.new.create(attributes)
  end

  def self.update(token:, attributes: {})
    DeadMansSnitchApi::Api.new.update(token, attributes)
  end

  def self.pause(token:)
    DeadMansSnitchApi::Api.new.pause(token)
  end

  def self.delete(token:)
    DeadMansSnitchApi::Api.new.delete(token)
  end

  def self.notify(token:)
    DeadMansSnitchApi::Api.new.notify(token)
  end
end
