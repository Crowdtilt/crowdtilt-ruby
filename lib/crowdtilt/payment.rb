module Crowdtilt
  class Payment < Model
    
    def initialize(attributes)
      super attributes
      @user_id ||= user.id
      @campaign_id ||= campaign.id
      @card_id ||= card.id
    end
    
    uri_prefix '/campaigns/#{campaign_id}/payments'

    attr_accessor :amount, :user_fee_amount, :admin_fee_amount, :status, :modification_date, 
                  :metadata, :id, :uri, :creation_date, :campaign, :card, :user
                  
    attr_accessor :campaign_id, :user_id, :card_id  #fields only needed for resource creation

    coerce :user => 'Crowdtilt::User'
    coerce :campaign => 'Crowdtilt::Campaign'
    coerce :card => 'Crowdtilt::Card'

    def create_json
      { "payment" => { "amount"           => amount,
                       "user_fee_amount"  => user_fee_amount,
                       "admin_fee_amount" => admin_fee_amount,
                       "user_id"          => user_id,
                       "card_id"          => card_id,
                       "metadata"         => metadata } }
    end

    def update_json
      { "payment" => { "metadata"         => metadata } }
    end
  end

  class PaymentsArray < Array
    attr_reader :campaign, :pagination
    def initialize(campaign, payments, pagination)
      super payments
      @campaign = campaign
      @pagination = pagination
    end

    def find(id)
      Crowdtilt::Payment.new Crowdtilt.get("/campaigns/#{campaign.id}/payments/"+id).body['payment']
    end

    def build(params)
      Crowdtilt::Payment.new params.merge(:campaign => campaign)
    end

    def create(params)
      build(params).save
    end
  end
end