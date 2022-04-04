# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module UserAccounts
      User = Struct.new(
        :id,
        :uid,
        :full_name,
        :avatar_url,
        :email,
        :affiliate_id,
        :site_count,
        :created_at,
        :last_login,
        :login_providers,
        :onboarding_progress
      )

      LoginProviders = Struct.new(:content)
      OnboardingProgress = Struct.new(:slides)
      UserDateTime = Struct.new(:value)

      def self.user
        id = ""
        uid = ""
        full_name = ""
        avatar_url = ""
        email = ""
        affiliate_id = ""
        site_count = 0
        created_at = UserDateTime.new("")
        last_login = UserDateTime.new("")
        login_providers = LoginProviders.new([""])
        onboarding_progress = OnboardingProgress.new("")

        @user ||= User.new(
          id,
          uid,
          full_name,
          avatar_url,
          email,
          affiliate_id,
          site_count,
          created_at,
          last_login,
          login_providers,
          onboarding_progress
        )
      end

      def self.populate
        yield(user)
      end
    end
  end
end
