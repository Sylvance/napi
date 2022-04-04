# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module UserAccounts
      Account = Struct.new(
        :id,
        :name,
        :slug,
        :type,
        :capabilities,
        :billing_name,
        :billing_email,
        :billing_details,
        :billing_period,
        :payment_method_id,
        :type_name,
        :type_id,
        :owner_ids,
        :roles_allowed,
        :created_at,
        :updated_at
      )

      Capabilities = Struct.new(:sites, :collaborators)
      CapabilityAttributes = Struct.new(:included, :used)
      OwnerIDs = Struct.new(:content)
      RolesAllowed = Struct.new(:content)
      AccountDateTime = Struct.new(:value)

      def self.account
        id = ""
        name = ""
        slug = ""
        type = ""
        capabilities = Capabilities.new(sites, collaborators)
        billing_name = ""
        billing_email = ""
        billing_details = ""
        billing_period = ""
        payment_method_id = ""
        type_name = ""
        type_id = ""
        owner_ids = OwnerIDs.new([""])
        roles_allowed = RolesAllowed.new([""])
        created_at = AccountDateTime.new("")
        updated_at = AccountDateTime.new("")

        @account ||= Account.new(
          id,
          name,
          slug,
          type,
          capabilities,
          billing_name,
          billing_email,
          billing_details,
          billing_period,
          payment_method_id,
          type_name,
          type_id,
          owner_ids,
          roles_allowed,
          created_at,
          updated_at
        )
      end

      def self.populate
        yield(account)
      end

      private

      def sites
        CapabilityAttributes.new(0, 0)
      end

      def collaborators
        CapabilityAttributes.new(0, 0)
      end
    end
  end
end
