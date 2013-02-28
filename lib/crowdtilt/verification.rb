module Crowdtilt
  class Verification < Model
    attr_accessor :name, :dob, :phone_number, :street_address, :postal_code, :user

    def save
      errors.add :user, "can not be nil" and return false if user.nil?
      Crowdtilt.post("/users/#{user.id}/verification", 
                     verification: {
                       name: name,
                       dob:  dob,
                       phone_number: phone_number,
                       street_address: street_address,
                       postal_code: postal_code
                     })
      true
    rescue Exception => e
      errors.add :general, e.message
      false
    end
  end
end