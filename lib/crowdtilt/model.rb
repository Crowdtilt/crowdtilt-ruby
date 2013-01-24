module Crowdtilt
  class Model
    include ActiveModel::Validations
    include ActiveModel::Serialization

    def initialize(attributes)
      deserialize attributes
    end

    def persisted?
      !!id
    end

    # @todo remove me
    def self.property(p,opts={})
      attr_accessor *p
    end

    class << self
      def uri_prefix(val=nil)
        @uri_prefix = val if val
        @uri_prefix
      end

      def coerce(hash)
        coercions.merge! hash
      end
    
      def coercions
        @coercions ||= {}
        @coercions
      end
    end

    def save
      raise "uri_prefix not specified for #{self.class}" unless uri_prefix
      if id
        Crowdtilt.put("#{uri_prefix}/#{id}", self.update_json)
      else
        deserialize Crowdtilt.post(uri_prefix, self.create_json).body[model_key]
      end
      true
    # rescue Exception => e
    #   errors.add :general, e.message
    #   false
    end

    def delete
      Crowdtilt.delete("#{uri_prefix}/#{id}")
    end

    module Finders
      extend ActiveSupport::Concern
      included do
        class << self
          def all
            Crowdtilt.get(uri_prefix).body[plural_model_key].map{|h| self.new(h)}
          end

          def find(id)
            self.new Crowdtilt.get("#{uri_prefix}/#{id}").body[model_key]
          end
        end
      end
    end

  protected

    def deserialize(attributes)
      attributes ||= {}
      attributes.keys.each do |key|
        if coercion = self.class.coercions[key.to_sym]
          _klass = eval(coercion)
          val = attributes[key].kind_of?(_klass) ? attributes[key] : _klass.new(attributes[key])
          self.send :"#{key}=", val
        else
          self.send :"#{key}=", attributes[key]
        end
      end
    end

    def uri_prefix
      eval("\"" + self.class.uri_prefix + "\"")
    end

    def model_key
      self.class.model_key
    end

    class << self
      def model_key
        model_name.split("::").last.downcase
      end

      def plural_model_key
        [model_key,"s"].join
      end
    end
  end
end