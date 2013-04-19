module Crowdtilt
  class Campaign < Model
    include Crowdtilt::Model::Finders

    def initialize(attributes)
      super attributes
      @user_id ||= admin.id
    end

    uri_prefix '/campaigns'

    attr_accessor :admin, :creation_date, :expiration_date, :fixed_payment_amount, :first_contributor, 
                  :id, :img, :is_tilted, :is_paid, :is_expired, :metadata, :min_payment_amount,
                  :modification_date, :payments_uri, :privacy, :settlements_uri, :stats, :tax_id,
                  :tax_name, :tilter, :tilt_amount, :title, :type, :uri
                  
    attr_accessor :user_id #fields only needed for resource creation

    coerce :admin => 'Crowdtilt::User'
    coerce :tilter => 'Crowdtilt::User'

    def create_json
      { "campaign" => { "user_id"          => user_id,
                        "title"            => title,
                        "expiration_date"  => expiration_date,
                        "tilt_amount"      => tilt_amount,
                        "metadata"         => metadata } }
    end
    
    def update_json
      { "campaign" => { "title"            => title,
                        "expiration_date"  => expiration_date,
                        "tilt_amount"      => tilt_amount, 
                        "metadata"         => metadata } }
    end

    def payments(page = 1, per_page = 50)
      raise "Can't verify a user without an ID" unless id
      
      payments = Crowdtilt.get("/campaigns/#{id}/payments?page=#{page}&per_page=#{per_page}")
      
      Crowdtilt::PaymentsArray.new self, payments.body['payments'].map{|h| Crowdtilt::Payment.new(h)}, payments.body['pagination']
    end
  end

  class UserCampaignsArray < Array
    attr_reader :user
    def initialize(user, campaigns)
      super campaigns
      @user = user
    end

    def find(id)
      Crowdtilt::Campaign.new Crowdtilt.get("campaigns/"+id).body['campaign']
    end

    def build(params)
      Crowdtilt::Campaign.new params.merge(:user => user.as_json)
    end

    def create(params)
      build(params).save
    end
  end
end