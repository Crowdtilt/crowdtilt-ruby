module Crowdtilt
  class Card < Model
    attr_accessor :expiration_month, :expiration_year,:card_type, :creation_date, :id,
                  :last_four, :metadata, :user, :uri
    
    attr_accessor :number, :security_code #fields only needed for resource creation

    coerce :user => 'Crowdtilt::User'

    uri_prefix '/users/#{user.id}/cards'

    def create_json
      { "card" => { "expiration_month" => expiration_month,
                    "expiration_year"  => expiration_year,
                    "number"           => number,
                    "security_code"    => security_code,
                    "metadata"         => metadata } }
    end

    def update_json
      { "card" => { "metadata" => metadata } }
    end
  end

  class CardsArray < Array
    attr_reader :user
    def initialize(user, cards)
      super cards
      @user = user
    end

    def find(id)
      Crowdtilt::Card.new Crowdtilt.get("/users/#{user.id}/cards/"+id).body['card'].merge(:user => user)
    end

    def build(params)
      Crowdtilt::Card.new params.merge(:user => user.as_json)
    end

    def create(params)
      build(params).save
    end
  end
end