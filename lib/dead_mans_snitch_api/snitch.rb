# frozen_string_literal: true

class DeadMansSnitchApi
  class Snitch
    ALL_ATTRIBUTES = {
      token: String,
      href: String,
      name: String,
      tags: Array,
      notes: String,
      status: String,
      created_at: String,
      check_in_url: String,
      checked_in_at: String,
      type: Hash,
      interval: String,
      alert_type: String,
      alert_email: Array,
    }.freeze

    MUTABLE_ATTRIBUTES = ALL_ATTRIBUTES.slice(
      *(ALL_ATTRIBUTES.keys - %i[token href status created_at check_in_url]),
    )

    def initialize(args = {})
      ALL_ATTRIBUTES.each do |attr, type|
        instance_variable_set(
          "@#{attr}",
          type.try_convert(args.fetch(attr.to_sym)),
        )
      end
    end

    ALL_ATTRIBUTES.each do |attr, _type|
      attr_reader attr
    end

    MUTABLE_ATTRIBUTES.each do |attr, type|
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", type.try_convert(value))
      end
    end

    def self.from_json(json)
      new(json.transform_keys(&:to_sym))
    end
  end
end
