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
  SNITCH_URI = Addressable::Template.new("https://nosnch.in/{token}")
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

  def self.delete(token:, override_request_options: {})
    new(**override_request_options).delete(token)
  end

  def self.notify(token:, override_request_options: {})
    new(**override_request_options).notify(token)
  end

  def get(token)
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}")

    request = handle_request(method: :get, url: uri.expand(token: token))

    DeadMansSnitchApi::Snitch.from_json(request)
  end

  def all_snitches(tags = [])
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{?tags}")

    request = handle_request(method: :get, url: uri.expand(tags: tags))

    request.map { |snitch| DeadMansSnitchApi::Snitch.from_json(snitch) }
  end

  def create(attributes)
    uri = Addressable::Template.new("#{BASE_URI}/snitches")

    request = handle_request(
      method: :post,
      url: uri.expand({}),
      payload: attributes.to_json,
    )

    DeadMansSnitchApi::Snitch.from_json(request)
  end

  def update(token, attributes = {})
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}")

    request = handle_request(
      method: :patch,
      url: uri.expand(token: token),
      payload: attributes.to_json,
    )

    DeadMansSnitchApi::Snitch.from_json(request)
  end

  def pause(token)
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}/pause")

    handle_request(method: :post, url: uri.expand(token: token))
  end

  def delete(token)
    uri = Addressable::Template.new("#{BASE_URI}/snitches/{token}")

    handle_request(method: :delete, url: uri.expand(token: token))
  end

  def notify(token)
    handle_request(method: :get, url: SNITCH_URI.expand(token: token))
  end

  private

  attr_reader :request_options

  def handle_request(method:, url:, **additional_params)
    response = RestClient::Request.execute(
      method: method,
      url: url.to_s,
      **additional_params,
      **request_options,
    )

    handle_response(response)
  rescue RestClient::ExceptionWithResponse => e
    raise RequestError, "Error: #{e} | Request: #{e.http_body}"
  end

  def handle_response(response)
    case response.code
    when 200, 201 then JSON.parse(response.body)
    when 202, 204 then true
    else
      raise RequestError, response.body
    end
  end
end
