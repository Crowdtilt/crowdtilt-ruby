module Crowdtilt
  class User < Model
    include Crowdtilt::Model::Finders
    uri_prefix '/users'
    
    attr_accessor :id, :name, :firstname, :lastname, :email,
                  :is_verified, :creation_date, :modification_date,
                  :uri, :campaigns_uri, :paid_campaigns_uri, :payments_uri,
                  :cards_uri, :banks_uri, :metadata

    def create_json
      { "user" => { "firstname" => firstname,
                    "lastname"  => lastname,
                    "email"     => email,
                    "metadata"  => metadata } }
    end
    alias_method :update_json, :create_json

    def name=(name)
      _a = name.split(' ')
      @name      = name
      @firstname = _a[0]
      @lastname  = _a[1..-1].join(' ')
    end

    def name
      @name ||= [firstname,lastname].join(' ')
    end

    def verified?
      @is_verified.to_s == '1'
    end

    def campaigns
      raise "Can't verify a user without an ID" unless id
      Crowdtilt::UserCampaignsArray.new self, Crowdtilt.get("/users/#{id}/campaigns").body['campaigns'].map{|h| Crowdtilt::Campaign.new(h)}
    end

    def card(params)
      raise "Can't create a card for a user without an ID" unless id
      card = Crowdtilt::Card.new params.merge(user: self)
      card.save
      card
    end

    def cards
      raise "Can't load cards for a user without an ID" unless id
      Crowdtilt::CardsArray.new self, Crowdtilt.get("/users/#{id}/cards").body['cards'].map{|h| Crowdtilt::Card.new(h)}
    end
    
    def create_bank(params)
      raise "Can't create a bank for a user without an ID" unless id
      bank = Crowdtilt::Bank.new params.merge(user: self)
      bank.save
      bank
    end
    
    def get_bank(bank_id)
      raise "Can't load bank for a user without an ID" unless id
      Crowdtilt::Bank.new Crowdtilt.get("/users/#{id}/banks/#{bank_id}").body['bank']
    end
     
    def get_banks
      raise "Can't load banks for a user without an ID" unless id
      Crowdtilt::BanksArray.new self, Crowdtilt.get("/users/#{id}/banks").body['banks'].map{|h| Crowdtilt::Bank.new(h)}
    end
    
    def get_default_bank
      raise "Can't load the default bank for a user without an ID" unless id
      Crowdtilt::Bank.new Crowdtilt.get("/users/#{id}/banks/default").body['bank']
    end

    def payments
      raise "Can't load payments for a user without an ID" unless id
      Crowdtilt.get("/users/#{id}/payments").body['payments'].map{|h| Crowdtilt::Payment.new(h)}
    end
    
    def verify(params = {})
      raise "Can't verify a user without an ID" unless id
      verified? ? true : Crowdtilt.post("/users/#{id}/verification", verification: params)
    end
    
  end
end