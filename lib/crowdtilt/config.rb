module Crowdtilt
  class Config
    def initialize(&block)
      instance_eval(&block) if block
    end

    def key(val=nil)
      @key ||= val
      @key
    end

    def secret(val=nil)
      @secret ||= val
      @secret
    end

    def env(val=nil)
      if val and not ['development','production'].include? val
        raise "Unknown env '#{env}'"
      end
      @env ||= (val || "development")
      @env
    end

    def url
      case env
      when "development"
        'https://api-sandbox.crowdtilt.com'
      when "production"
        'https://api.crowdtilt.com'
      end
    end
  end
end