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

  def self.get(token:, override_request_options: {})
    new(**override_request_options).get(token)
  end

  def self.create(attributes: {}, override_request_options: {})
    new(**override_request_options).create(attributes)
  end

  def self.update(token:, attributes: {}, override_request_options: {})
    new(**override_request_options).update(token, attributes)
  end

  def self.pause(token:, override_request_options: {})
    new(**override_request_options).pause(token)
  end

  def get(token)
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}")

    request = handle_request do
      RestClient::Request.execute(
        method: :get,
        url: uri.expand(token: token).to_s,
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

  def update(token, attributes = {})
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}")

    request = handle_request do
      RestClient::Request.execute(
        method: :patch,
        url: uri.expand(token: token).to_s,
        payload: attributes.to_json,
        **request_options,
      )
    end

    DeadMansSnitchApi::Snitch.from_json(request)
  end

  def pause(token)
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}/pause")

    handle_request do
      RestClient::Request.execute(
        method: :post,
        url: uri.expand(token: token).to_s,
        **request_options,
      )
    end

    true
  end

  private

  attr_reader :request_options

  def handle_request
    request = yield

    if SUCCESS_CODES.include?(request.code) && request.code != 204
      JSON.parse(request.body)
    elsif request.code == 204
      true
    else
      raise RequestError, request.body
    end
  rescue RestClient::ExceptionWithResponse => e
    raise RequestError, "Error: #{e} | Request: #{e.http_body}"
  end
end
