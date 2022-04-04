# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module UserAccounts
      AccessType = Struct.new(
        :id,
        :name,
        :description,
        :capabilities,
        :monthly_dollar_price,
        :yearly_dollar_price,
        :monthly_seats_addon_dollar_price,
        :yearly_seats_addon_dollar_price
      )

      Capabilities = Struct.new(:content)
      Price = Struct.new(:value)

      def self.access_type
        id = ""
        name = ""
        description = ""
        capabilities = Capabilities.new({})
        monthly_dollar_price = Price.new(0)
        yearly_dollar_price = Price.new(0)
        monthly_seats_addon_dollar_price = Price.new(0)
        yearly_seats_addon_dollar_price = Price.new(0)

        @access_type ||= AccessType.new(
          id,
          name,
          description,
          capabilities,
          monthly_dollar_price,
          yearly_dollar_price,
          monthly_seats_addon_dollar_price,
          yearly_seats_addon_dollar_price
        )
      end

      def self.populate
        yield(access_type)
      end
    end
  end
end
