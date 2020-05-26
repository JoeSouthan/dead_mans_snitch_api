# frozen_string_literal: true

require "dry-struct"

class DeadMansSnitchApi
  class Snitch < Dry::Struct
    transform_keys(&:to_sym)

    attribute :name, Dry.Types()::String
    attribute :alert_type, Dry.Types()::String
    attribute :interval, Dry.Types()::String
    attribute? :tags, Dry.Types()::Array.optional
    attribute? :alert_email, Dry.Types()::Array.optional
    attribute? :notes, Dry.Types()::String.optional

    attribute? :token, Dry.Types()::String.optional
    attribute? :href, Dry.Types()::String.optional
    attribute? :status, Dry.Types()::String.optional
    attribute? :created_at, Dry.Types()::String.optional
    attribute? :check_in_url, Dry.Types()::String.optional
    attribute? :checked_in_at, Dry.Types()::String.optional
    attribute? :type, Dry.Types()::Hash.optional

    MUTABLE_ATTRIBUTES = %i[name tags notes interval alert_type alert_email].freeze

    def params
      to_h.slice(*MUTABLE_ATTRIBUTES)
    end

    def persisted?
      !!token
    end

    def save
      create unless persisted?
      # request = DeadMansSnitchApi.update(attributes: params)

      # attributes.merge!(request.to_h)

      # self
    end

    def create
      request = DeadMansSnitchApi.create(attributes: params)

      attributes.merge!(request.to_h)

      self
    end

    def self.from_json(json)
      new(json.transform_keys(&:to_sym))
    end
  end
end
