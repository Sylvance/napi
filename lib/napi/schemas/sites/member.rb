# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module UserAccounts
      Member = Struct.new(
        :id,
        :full_name,
        :email,
        :avatar,
        :role
      )

      def self.member
        id = ""
        full_name = ""
        email = ""
        avatar = ""
        role = ""

        @member ||= Member.new(
          id,
          full_name,
          email,
          avatar,
          role
        )
      end

      def self.populate
        yield(member)
      end
    end
  end
end
