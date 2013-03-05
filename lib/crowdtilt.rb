require 'active_model'
require 'faraday'
require 'faraday_middleware'
require 'json'

require File.dirname(__FILE__) + "/crowdtilt/config"
require File.dirname(__FILE__) + "/crowdtilt/model"
require File.dirname(__FILE__) + "/crowdtilt/bank"
require File.dirname(__FILE__) + "/crowdtilt/campaign"
require File.dirname(__FILE__) + "/crowdtilt/card"
require File.dirname(__FILE__) + "/crowdtilt/user"
require File.dirname(__FILE__) + "/crowdtilt/payment"

module Crowdtilt

  class << self
    def configure(&block)
      @config = Crowdtilt::Config.new(&block)
    end

    def config
      if @config.nil?
        raise "Crowdtilt not initialized, please configure using Crowdtilt.configure"
      end
      @config
    end

    def request(method,*args)
      conn = Faraday.new(:url => config.url) do |faraday|
        # faraday.response :logger
        faraday.request :json
        faraday.response :json, :content_type => /\bjson$/
        faraday.use :instrumentation

        faraday.adapter Faraday.default_adapter
      end
      conn.basic_auth(config.key, config.secret)
      conn.headers.update({'Content-Type' => 'application/json'})
      
      res = conn.send method.to_sym, *args
      
      if config.env == "development" || config.env == "local"
        puts 
        puts "#{method.to_s.upcase} #{args[0]} #{args[1]}"
        puts "Response #{res.status}"
        puts res.body if res.body
        puts
      end
      
      case res.status
      when 400...499
        raise res.body['error']
      when 500...599
        # prob want to handle this differently
        raise res.body['error']
      else
        res
      end
    end

    def get(path)
      request :get, "/v1#{path}"
    end

    def post(path, params={})
      request :post, "/v1#{path}", params
    end

    def put(path, params={})
      request :put, "/v1#{path}", params
    end

    def delete(path)
      request :delete, "/v1#{path}"
    end
  end
end