# frozen_string_literal: true

require "uri"
require "net/http"
require "openssl"
require "ostruct"
require "json"

# Ruby gem that helps you work with Netlify API.
module Napi
  # Http client that acts as a middleman to the API.
  class HttpClient
    NET_HTTP_ERRORS = [
      Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
      JSON::ParserError, SocketError
    ].freeze

    def self.call(method:, uri:, body: nil, params: nil, headers: nil, auth: nil, expect: nil)
      new(method, uri, body, params, headers, auth, expect).call
    end

    def initialize(method, uri, body, params, headers, auth, expect)
      @method  = method
      @body    = body
      @headers = headers
      @auth    = auth
      @url     = prepare_uri(uri, params)
      @expect  = expect.nil? ? :json : expect
      @http    = prepare_http
      @request = prepare_request
    end

    def call
      response
    end

    private

    attr_accessor :auth, :body, :expect, :headers, :http, :method, :request, :url

    def response
      http_response = http.request(request)

      if http_response.is_a?(Net::HTTPSuccess)
        result = Napi.to_ostruct(JSON.parse(http_response.read_body)) if expect == :json
        result = http_response.read_body if expect == :html
        result_struct(result, http_response, true)
      else
        result_struct(nil, http_response, false)
      end
    rescue *NET_HTTP_ERRORS => e
      result_struct(e, http_response, false)
    end

    def result_struct(result, response, success)
      OpenStruct.new(
        result: result,
        headers: Napi.to_ostruct(response.to_hash),
        code: response.code,
        message: response.message,
        class: response.class.name,
        successful?: success
      )
    end

    def prepare_uri(uri, params)
      build_url = URI(uri)
      build_url.query = URI.encode_www_form(params) unless params.nil?
      build_url
    end

    def prepare_http
      protocol = Net::HTTP.new(url.host, url.port)
      protocol.use_ssl = true
      protocol.verify_mode = OpenSSL::SSL::VERIFY_NONE
      protocol
    end

    def prepare_request
      req = build_request
      req.basic_auth(auth[:user], auth[:password]) unless auth.nil?
      req.body = JSON.dump(body) unless body.nil?
      req
    end

    def build_request
      return Net::HTTP::Get.new(url, headers)     if method == :get
      return Net::HTTP::Post.new(url, headers)    if method == :post
      return Net::HTTP::Put.new(url, headers)     if method == :put
      return Net::HTTP::Patch.new(url, headers)   if method == :patch
      return Net::HTTP::Delete.new(url, headers)  if method == :delete
      return Net::HTTP::Options.new(url, headers) if method == :options
    end
  end
end
