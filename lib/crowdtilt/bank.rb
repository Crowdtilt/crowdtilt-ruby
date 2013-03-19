module Crowdtilt
  class Bank < Model
    attr_accessor :name, :account_number_last_four, :bank_code_last_four, :id, 
                  :is_default, :metadata, :user, :uri, :creation_date, :modification_date
    
    attr_accessor :account_number, :bank_code #fields only needed for resource creation

    uri_prefix '/users/#{user.id}/banks'

    coerce :user => 'Crowdtilt::User'

    def create_json
      { "bank" => { "account_number" => account_number,
                    "name"           => name,
                    "bank_code"      => bank_code,
                    "metadata"       => metadata } }
    end

    def update_json
      { "bank" => { "metadata" => metadata } }
    end
    
    def set_as_default
      Crowdtilt::Bank.new Crowdtilt.post("/users/#{user.id}/banks/default", bank: { id: id }).body['bank'].merge(:user => user)
    end
    
  end

  class BanksArray < Array
    attr_reader :user
    def initialize(user, banks)
      super banks
      @user = user
    end

    def find(id)
      Crowdtilt::Bank.new Crowdtilt.get("/users/#{user.id}/banks/"+id).body['bank']
    end

    def build(params)
      Crowdtilt::Bank.new params.merge(:user => user.as_json)
    end

    def create(params)
      build(params).save
    end
  end
end