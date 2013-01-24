# Crowdtilt Ruby Library

## Introduction

This is a very rudimentary shot at implementing the Crowdtilt API.  Feel free to add support for missing ones.

While continued development happens on the Crowdtilt API, I opted to forego specs conforming to the API schema since determining when changes happened were easier if the HTTP call blew up.  This should really be fixed in the future once the schema solidifies.

## Usage

First start by configuring Crowdtilt:

```
Crowdtilt.configure do
  key "KEY"
  secret "SECRET"
  env "production" # not setting this will default to "development"
end
```

If you're using Rails:

```
Crowdtilt.configure do
  key "KEY"
  secret "SECRET"
  env Rails.env
end
```

You should be good to go.  Example usage:

```
# Create a user
u = Crowdtilt::User.new(:name => 'Ian', :email => 'ian@example.org')
u.persisted? #=> false
u.save 
u.persisted? #=> true

# List all users
Crowdtilt::User.all
#=> [Crowdtilt::User,...]

c = u.campaigns.create "title"            => "Foo",
                       "description"      => "Bar",
                       "expiration_date"  => 2.weeks.from_now,
                       "tilt_amount"      => 1000
```

## Issues

Bound to be some issues since there's barely any specs.  Feel free to submit an issue.

## Endpoints Supported

* [✓] POST /users
* [✓] POST /users/:id/verification
* [ ] GET /users/authentication?email=x&password=y
* [✓] GET  /users/:id
* [✓] GET /users
* [✓] PUT /users/:id
* [✓] GET /users/:id/campaigns
* [✓] GET /users/:id/campaigns/:id
* [ ] GET /users/:id/paid_campaigns
* [✓] POST /users/:id/cards
* [✓] GET /users/:id/cards/:id
* [✓] GET /users/:id/cards
* [✓] PUT /users/:id/cards/:id
* [✓] DELETE /users/:id/cards/:id
* [✓] POST /users/:id/banks  
* [✓] GET /users/:id/banks/:id
* [✓] GET /users/:id/banks
* [✓] PUT /users/:id/banks/:id
* [✓] DELETE /users/:id/banks/:id
* [✓] GET /users/:id/payments
* [✓] POST /campaigns
* [✓] GET  /campaigns/:id
* [✓] GET /campaigns
* [✓] PUT /campaigns/:id
* [✓] POST /campaigns/:id/payments
* [✓] GET /campaigns/:id/payments/:id
* [✓] PUT /campaigns/:id/payments/:id
* [✓] GET /campaigns/:id/payments
* [ ] GET /campaigns/:id/rejected_payments
* [ ] POST /campaigns/:id/payments/:id/refund
* [ ] GET /campaigns/:id/settlements
* [ ] GET /campaigns/:id/settlements/:id
* [ ] POST /campaigns/:id/settlements/:id/bank
* [ ] POST /campaigns/:id/comments
* [ ] GET /campaigns/:id/comments
* [ ] GET /campaigns/:id/comments/:id
* [ ] PUT /campaigns/:id/comments/:id
* [ ] DELETE /campaigns/:id/comments/:id

## Todo

* The association-like chaining executes the all http call before doing the find, or other method calls.  Lazy eval the associated array so we don't do 2 calls.