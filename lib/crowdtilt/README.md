= Endpoints
[✓] POST /users
[✓] POST /users/:id/verification
[ ] GET /users/authentication?email=x&password=y
[✓] GET  /users/:id
[✓] GET /users
[✓] PUT /users/:id
[✓] GET /users/:id/campaigns
[e] GET /users/:id/campaigns/:id
  This returns 200 status when it's actually 404
[ ] GET /users/:id/paid_campaigns
[✓] POST /users/:id/cards
[✓] GET /users/:id/cards/:id
[✓] GET /users/:id/cards
[✓] PUT /users/:id/cards/:id
[✓] DELETE /users/:id/cards/:id
[✓] POST /users/:id/banks  
[✓] GET /users/:id/banks/:id
[✓] GET /users/:id/banks
[✓] PUT /users/:id/banks/:id
[✓] DELETE /users/:id/banks/:id
[✓] GET /users/:id/payments
[✓] POST /campaigns
[✓] GET  /campaigns/:id
[✓] GET /campaigns
[✓] PUT /campaigns/:id
[✓] POST /campaigns/:id/payments
  This returns campaign_id, user_id, card_id, not object hashes
[✓] GET /campaigns/:id/payments/:id
[✓] PUT /campaigns/:id/payments/:id
[✓] GET /campaigns/:id/payments
[ ] GET /campaigns/:id/rejected_payments
[ ] POST /campaigns/:id/payments/:id/refund
[ ] GET /campaigns/:id/settlements
[ ] GET /campaigns/:id/settlements/:id
[ ] POST /campaigns/:id/settlements/:id/bank
[ ] POST /campaigns/:id/comments
[ ] GET /campaigns/:id/comments
[ ] GET /campaigns/:id/comments/:id
[ ] PUT /campaigns/:id/comments/:id
[ ] DELETE /campaigns/:id/comments/:id

= Questions
* Is there no delete user endpoint?

= Todo
* The association-like chaining executes the all http call before doing the find, or other method calls.  Lazy eval the associated array so we don't do 2 calls.