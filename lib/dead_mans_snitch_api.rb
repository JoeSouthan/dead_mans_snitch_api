# frozen_string_literal: true

require "rest-client"
require "addressable/uri"
require "addressable/template"
require "json"

require_relative "dead_mans_snitch_api/snitch"

class DeadMansSnitchApi
  class RequestError < StandardError; end

  GEM_VERSION = "0.1.0"
  BASE_URI = Addressable::URI.parse("https://api.deadmanssnitch.com/v1")
  SUCCESS_CODES = [200, 201, 204].freeze
  DEFAULT_REQUEST_OPTIONS = {
    user: ENV.fetch("DMS_API_KEY", "1234"),
    headers: {
      content_type: "application/json",
      accept: "application/json",
    },
  }.freeze

  def initialize(override_request_options: {})
    @request_options = DEFAULT_REQUEST_OPTIONS.merge(override_request_options)
  end

  def self.all_snitches(override_request_options: {})
    new(**override_request_options).all_snitches
  end

  def self.get(id:, override_request_options: {})
    new(**override_request_options).get(id)
  end

  def self.create(attributes: {}, override_request_options: {})
    new(**override_request_options).create(attributes)
  end

  def get(id)
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{id}")

    request = handle_request do
      RestClient::Request.execute(
        method: :get,
        url: uri.expand(id: id).to_s,
        **request_options,
      )
    end

    DeadMansSnitchApi::Snitch.from_json(request)
  end

  def all_snitches(tags = [])
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{?tags}")

    request = handle_request do
      RestClient::Request.execute(
        method: :get,
        url: uri.expand(tags: tags).to_s,
        **request_options,
      )
    end

    request.map { |snitch| DeadMansSnitchApi::Snitch.from_json(snitch) }
  end

  def create(attributes)
    uri = Addressable::Template.new("#{BASE_URI}/snitches")

    request = handle_request do
      RestClient::Request.execute(
        method: :post,
        url: uri.expand({}).to_s,
        payload: attributes.to_json,
        **request_options,
      )
    end

    DeadMansSnitchApi::Snitch.from_json(request)
  end

  private

  attr_reader :request_options

  def handle_request
    request = yield

    if SUCCESS_CODES.include?(request.code)
      JSON.parse(request.body)
    else
      raise RequestError, request.body
    end
  rescue RestClient::ExceptionWithResponse => e
    raise RequestError, "Error: #{e} | Request: #{e.http_body}"
  end
end
