module Crowdtilt
  class Payment < Model
    uri_prefix '/campaigns/#{campaign.id}/payments'

    attr_accessor :amount, :user_fee_amount, :admin_fee_amount, :user_id, :card_id

    attr_accessor :status, :modification_date, :metadata, :id, :uri, :creation_date,
                  :campaign, :campaign_id, :card, :user

    coerce :user => 'Crowdtilt::User'
    coerce :campaign => 'Crowdtilt::Campaign'
    coerce :card => 'Crowdtilt::Card'

    def create_json
      { "payment" => { "amount"           => amount,
                       "user_fee_amount"  => user_fee_amount,
                       "admin_fee_amount" => admin_fee_amount,
                       "user_id"          => user_id,
                       "card_id"          => card_id } }
    end

    def update_json
      { "payment" => { "metadata"         => metadata } }
    end
  end

  class PaymentsArray < Array
    attr_reader :campaign
    def initialize(campaign, cards)
      super cards
      @campaign = campaign
    end

    def find(id)
      Crowdtilt::Payment.new Crowdtilt.get("/campaigns/#{campaign_id}/payments/"+id).body['payment']
    end

    def build(params)
      Crowdtilt::Payment.new params.merge(:campaign => campaign)
    end

    def create(params)
      build(params).save
    end
  end
end