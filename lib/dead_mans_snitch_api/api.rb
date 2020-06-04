# frozen_string_literal: true

class DeadMansSnitchApi
  class Api
    BASE_URI = Addressable::URI.parse("https://api.deadmanssnitch.com/v1")
    SNITCH_URI = Addressable::Template.new("https://nosnch.in/{token}")

    DEFAULT_REQUEST_OPTIONS = {
      user: DeadMansSnitchApi.config.api_key,
      headers: {
        content_type: "application/json",
        accept: "application/json",
      },
    }.freeze

    def initialize(override_request_options: {})
      @request_options = DEFAULT_REQUEST_OPTIONS.merge(override_request_options)
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
end
