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
  TEST_API_KEY = "1234"

  def initialize(options)
    @request_options = {
      user: ENV.fetch("DMS_API_KEY", TEST_API_KEY),
      content_type: :json,
      accept: :json,
    }.merge(options)
  end

  def self.all_snitches(options: {})
    new(**options).all_snitches
  end

  def self.get_snitch(id:, options: {})
    new(**options).get_snitch(id)
  end

  def get_snitch(id)
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

  def all_snitches
    uri = Addressable::Template.new("#{BASE_URI}/snitches")

    request = handle_request do
      RestClient::Request.execute(
        method: :get,
        url: uri.expand({}).to_s,
        **request_options,
      )
    end

    request.map { |snitch| DeadMansSnitchApi::Snitch.from_json(snitch) }
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
    raise RequestError, response.body
  end
end
