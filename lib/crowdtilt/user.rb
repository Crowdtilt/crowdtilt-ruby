module Crowdtilt
  class User < Model
    include Crowdtilt::Model::Finders
    uri_prefix '/users'
    
    attr_accessor :id, :name, :firstname, :lastname, :email,
                  :is_verified, :img, :creation_date, :last_login_date,
                  :uri, :campaigns_uri, :paid_campaigns_uri, :payments_uri,
                  :metadata

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
      card = Crowdtilt::Card.new params.merge(user: self)
      card.save
      card
    end

    def cards
      raise "Can't load cards for a user without an ID" unless id
      Crowdtilt::CardsArray.new self, Crowdtilt.get("/users/#{id}/cards").body['cards'].map{|h| Crowdtilt::Card.new(h.merge(:user => self.as_json))}
    end
    
    def bank(params)
      bank = Crowdtilt::Bank.new params.merge(user: self)
      bank.save
      bank
    end

    def banks
      raise "Can't load banks for a user without an ID" unless id
      Crowdtilt::BanksArray.new self, Crowdtilt.get("/users/#{id}/banks").body['banks'].map{|h| Crowdtilt::Bank.new(h)}
    end

    def payments
      Crowdtilt.get("/users/#{id}/payments").body['payments'].map{|h| Crowdtilt::Payment.new(h)}
    end
    
    def verify(params = {})
      if @is_verified == 0
        verification = Crowdtilt::Verification.new :user => self, :name => params[:name], :dob => params[:dob], 
                                                   :phone_number => params[:phone_number], :street_address => params[:street_address], 
                                                   :postal_code => params[:postal_code]
        if verification.save
          @is_verified = 1
          true
        else
          false
        end
      else
        true
      end
    end
    
  end
end