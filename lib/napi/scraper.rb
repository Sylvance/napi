# frozen_string_literal: true

require "fileutils"
require "json"
require "nokogiri"
require "ostruct"

require_relative "http_client"

# Netlify API gem
module Napi
  # Scrapes the Netlify API documentation into recognizable parts.
  class Scraper
    attr_accessor :url, :version

    def self.scrape(url:, version:)
      new(url, version).scrape
    end

    def initialize(url, version)
      @url     = url
      @version = version
    end

    def scrape
      hash = { result: list }

      FileUtils.mkdir_p("lib/napi/public/api/v#{version}")
      FileUtils.touch("lib/napi/public/api/v#{version}/netlify_api.json")
      File.open("lib/napi/public/api/v#{version}/netlify_api.json", "w") do |f|
        f.write(JSON.pretty_generate(hash))
      end
    end

    private

    def list
      page     = download_link_page
      document = parse(page)

      table_list(document)
    end

    def download_link_page
      Napi::HttpClient.call(method: :get, uri: url, expect: :html).result
    end

    def parse(page)
      Nokogiri::HTML(page)
    end

    def table_list(document)
      list            = []
      namespace       = "/html/body/div/div/div[3]/div"
      namespace_count = document.xpath(namespace).size

      namespace_count.times do |namespace_index|
        next if namespace_index < 3

        blockspace = "#{namespace}[#{namespace_index + 1}]"
        verb       = "#{blockspace}/div/div[2]/div[1]/div[1]/span[1]"
        path       = "#{blockspace}/div/div[2]/div[1]/div[1]/span[2]"

        list << {
          verb: verb,
          path: path,
          path_params: path_params(document, blockspace),
          body_params: body_params(document, blockspace),
          query_params: query_params(document, blockspace)
        }
      end

      list
    end

    def path_params(document, blockspace)
      path_table = "#{blockspace}/div/div[1]/div[2]/table"
      document.xpath(path_table)
    end

    def body_params(document, blockspace)
      body_table = "#{blockspace}/div/div[1]/table/tr"
      document.xpath(body_table)
    end

    def query_params(document, blockspace)
      query_table = "#{blockspace}/div/div[1]/div[2]/table"
      document.xpath(query_table)
    end
  end
end
