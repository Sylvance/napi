# frozen_string_literal: true

require "ostruct"

require_relative "napi/http_client"
require_relative "napi/scraper"
require_relative "napi/version"

# Netlify API gem
module Napi
  class Error < StandardError; end
  class MissingApiKeyError < StandardError; end
  class InvalidApiKeyError < StandardError; end
  class MissingApiSecretError < StandardError; end
  class InvalidApiSecretError < StandardError; end

  Configuration = Struct.new(
    :base_url,
    :api_key,
    :api_secret
  )

  def self.configuration
    url = "https://api.netlify.com/api/v1/"
    api_key = ""
    api_secret = ""

    @configuration ||= Configuration.new(url, api_key, api_secret)
  end

  def self.configure
    yield(configuration)
  end

  def self.to_ostruct(input)
    result = {}

    if input.is_a?(Hash)
      result["result_type"] = input.class
      result["result_keys"] = input.keys

      input.each do |key, value|
        result[key] = hash_or_array(value) ? to_ostruct(value) : OpenStruct.new(value: value, result_type: value.class)
      end
    end

    if input.is_a?(Array)
      result["result_type"] = input.class
      result["result_array_size"] = input.size

      input.each.with_index do |value, index|
        result["value_at_#{index}"] = hash_or_array(value) ? to_ostruct(value) : OpenStruct.new(value: value, result_type: value.class)
      end
    end

    OpenStruct.new(result)
  end

  def self.hash_or_array(val)
    val.is_a?(Hash) || val.is_a?(Array)
  end
end
