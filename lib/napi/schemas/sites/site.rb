# frozen_string_literal: true

require "ostruct"
require_relative "napi/version"

# Netlify API gem
module Napi
  # Schemas module for a possible return values from the Netlify API
  module Schemas
    # Schema module for Netlify API User Accounts
    module Sites
      Site = Struct.new(
        :id,
        :state,
        :plan,
        :name,
        :custom_domain,
        :domain_aliases,
        :password,
        :notification_email,
        :url,
        :ssl_url,
        :admin_url,
        :screenshot_url,
        :created_at,
        :updated_at,
        :user_id,
        :session_id,
        :ssl,
        :force_ssl,
        :managed_dns,
        :deploy_url,
        :published_deploy,
        :account_name,
        :account_slug,
        :git_provider,
        :deploy_hook,
        :capabilities, # TODO: Capabilities has undefined properties that need to be mapped
        :processing_settings,
        :build_settings, # =#<OpenStruct id=0, provider, deploy_key_id, repo_path, repo_branch, dir, functions_dir, cmd, allowed_branches=["string"], public_repo=true, private_logs=true, repo_url, env =#<OpenStruct property1, property2>, installation_id=0, stop_builds=true>,
        :id_domain,
        :default_hooks_data, # =#<OpenStruct access_token>,
        :build_image,
        :prerender,
        :repo # =#<OpenStruct id=0, provider, deploy_key_id, repo_path, repo_branch, dir, functions_dir, cmd, allowed_branches=["string"], public_repo=true, private_logs=true, repo_url, env =#<OpenStruct property1, property2>, installation_id=0, stop_builds=true>>
      )

      DomainAliases = Struct.new(:content)
      Boolean = Struct.new(:boolean)
      SiteDateTime = Struct.new(:value)
      PublishedDeploy = Struct.new(
        :id,
        :site_id,
        :user_id,
        :build_id,
        :state,
        :name,
        :url,
        :ssl_url,
        :admin_url,
        :deploy_url,
        :deploy_ssl_url,
        :screenshot_url,
        :review_id,
        :draft,
        :required,
        :required_functions,
        :error_message,
        :branch,
        :commit_ref,
        :commit_url,
        :skipped,
        :created_at,
        :updated_at,
        :published_at,
        :title,
        :context,
        :locked,
        :review_url,
        :site_capabilities,
        :framework,
        :function_schedules
      )
      ProcessingSettings = Struct.new(:skip, :css, :js, :images, :html)
      AssetOptions = Struct.new(:bundle, :minify)
      ImagesOptions = Struct.new(:optimize)
      HTMLOptions = Struct.new(:pretty_urls)

      def self.site
        id = ""
        state = ""
        plan = ""
        name = ""
        custom_domain = ""
        domain_aliases = DomainAliases.new([""])
        password = ""
        notification_email = ""
        url = ""
        ssl_url = ""
        admin_url = ""
        screenshot_url = ""
        created_at = SiteDateTime.new("")
        updated_at = SiteDateTime.new("")
        user_id = ""
        session_id = ""
        ssl = Boolean.new(true)
        force_ssl = Boolean.new(true)
        managed_dns = Boolean.new(true)
        deploy_url = ""
        account_name = ""
        account_slug = ""
        git_provider = ""
        deploy_hook = ""
        capabilities = ""
        processing_settings = ProcessingSettings.new(Boolean.new(true), asset_options, asset_options, images_options, html_options)
        build_settings = ""
        id_domain = ""
        default_hooks_data = ""
        build_image = ""
        prerender = ""
        repo = ""

        @site ||= Site.new(
          id,
          state,
          plan,
          name,
          custom_domain,
          domain_aliases,
          password,
          notification_email,
          url,
          ssl_url,
          admin_url,
          screenshot_url,
          created_at,
          updated_at,
          user_id,
          session_id,
          ssl,
          force_ssl,
          managed_dns,
          deploy_url,
          published_deploy,
          account_name,
          account_slug,
          git_provider,
          deploy_hook,
          capabilities,
          processing_settings,
          build_settings,
          id_domain,
          default_hooks_data,
          build_image,
          prerender,
          repo
        )
      end

      def self.populate
        yield(site)
      end

      private

      def published_deploy
        PublishedDeploy.new(
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          :review_id, # 0,
          :draft, # true,
          :required, # : []
          :required_functions, # : []
          "",
          "",
          "",
          "",
          :skipped, # :: true,
          "",
          "",
          "",
          "",
          "",
          :locked, # :: true,
          "",
          :site_capabilities, # :: { :large_media_enabled:: true },
          "",
          :function_schedules, # :: [{ :name :: :string:, :cron:: :string: }]
        )
      end

      def asset_options
        AssetOptions.new(Boolean.new(true), Boolean.new(true))
      end

      def images_options
        ImagesOptions.new(Boolean.new(true))
      end

      def html_options
        HTMLOptions.new(Boolean.new(true))
      end
    end
  end
end
