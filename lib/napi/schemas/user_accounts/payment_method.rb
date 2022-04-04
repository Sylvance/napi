# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module UserAccounts
      PaymentMethod = Struct.new(
        :id,
        :method_name,
        :type,
        :state,
        :data,
        :created_at,
        :updated_at
      )

      Card = Struct.new(:card_type, :last4, :email)
      PaymentMethodDateTime = Struct.new(:value)

      def self.payment_method
        id = ""
        method_name = ""
        type = ""
        state = ""
        data = Card.new("", "", "")
        created_at = PaymentMethodDateTime.new("")
        updated_at = PaymentMethodDateTime.new("")

        @payment_method ||= PaymentMethod.new(
          id,
          method_name,
          type,
          state,
          data,
          created_at,
          updated_at
        )
      end

      def self.populate
        yield(payment_method)
      end
    end
  end
end
