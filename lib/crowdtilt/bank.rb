module Crowdtilt
  class Bank < Model
    attr_accessor :account_number, :name, :bank_code, :account_number_last_four,
                  :bank_code_last_four, :id, :is_valid, :metadata, :name, :user,
                  :user_uri, :uri

    uri_prefix '/users/#{user.id}/banks'

    coerce :user => 'Crowdtilt::User'

    def create_json
      { "bank" => { "account_number" => account_number,
                    "name"           => name,
                    "bank_code"      => bank_code } }
    end

    def update_json
      { "bank" => { "metadata" => metadata } }
    end
  end

  class BanksArray < Array
    attr_reader :user
    def initialize(user, banks)
      super banks
      @user = user
    end

    def find(id)
      Crowdtilt::Bank.new Crowdtilt.get("/users/#{user.id}/banks/"+id).body['bank'].merge(:user => user)
    end

    def build(params)
      Crowdtilt::Bank.new params.merge(:user => user.as_json)
    end

    def create(params)
      build(params).save
    end
  end
end