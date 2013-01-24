require ::File.expand_path('../../../config/environment',  __FILE__)

user = Crowdtilt::User.new(
         name: Faker::Name.name,
         email: Faker::Internet.email
       ).save

v = Crowdtilt::Verification.new(
      user: user,
      dob: "1984-07",
      phone_number: "(000) 000-0000", 
      street_address: "324 awesome address, awesome city, CA",
      postal_code: "12345"
    )

puts v.save
puts v.errors.inspect

# card = user.cards.create expiration_year:2023, security_code:123, expiration_month:"01", number:"4111111111111111" 

# campaign = Crowdtilt::Campaign.all.last

# payment = Crowdtilt::Payment.new(:user => user, :campaign => campaign, :card => card, :amount => 100, :user_fee_amount => 10, :admin_fee_amount => 10)
# payment.save

# puts campaign.payments.inspect
