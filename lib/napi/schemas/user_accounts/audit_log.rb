# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module UserAccounts
      AuditLog = Struct.new(
        :id,
        :account_id,
        :payload
      )

      # TODO: PAYLOAD has extra defined properties that need to be mapped
      Payload = Struct.new(:actor_id, :actor_name, :actor_email, :action, :timestamp, :log_type)
      AuditLogDateTime = Struct.new(:value)

      def self.audit_log
        id = ""
        account_id = ""
        payload = Payload.new("", "", "", "", timestamp, "")

        @audit_log ||= AuditLog.new(
          id,
          account_id,
          payload
        )
      end

      def self.populate
        yield(audit_log)
      end

      private

      def timestamp
        AuditLogDateTime.new("")
      end
    end
  end
end
