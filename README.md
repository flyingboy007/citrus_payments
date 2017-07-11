# CitrusPayments [![Build Status](https://travis-ci.org/flyingboy007/citrus_payments.svg?branch=master)](https://travis-ci.org/flyingboy007/citrus_payments)

A ruby gem for using the Citrus REST API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'citrus_payments'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install citrus_payments
    
In the initialiser add:


```ruby
CitrusPayments.configure do |config|
#will improve on this after finishing a layout so that it will dynamically change base_url between sandbox and production
  config.base_url =  "Put your citrus base_url here" 
  config.vanity_url = "Put your citrus vanity_url here"
  config.access_key = "Put your citrus access_key here"
  config.secret_key = "Put your citrus secret_key here"
end
```    

## Usage

TODO: Planned features

## Phase 1
### PAYMENT MAKING
  **Generate signature**
         
  Send payment details like this to generate signature     
  
  _payment_details = {
           orderAmount: '27',
           merchantTxnId: 'unique_merchant_txn_id',
           currency: 'inr'
       }_
       
 ` CitrusPayments::Utility.generate_signature(payment_details)`

  
  Decode signature
  
  Response Handling

## Phase 2
### SPLITPAY
######  a) User Authentication
   This API authenticates the ‘Merchant’ and returns an ‘auth_token’. This token is a mandatory parameter in the header and is required to run any subsequent APIs of Marketplace system
######  b) Seller API 
   1)Create - Merchant can on board his sellers
   2)Update  - Merchant can update existing sellers
   3)Get Seller - Merchant can get existing seller details
   4)Get All Seller - Merchant can get all the existing seller details created by him 
   5)Get Seller Account Balance(seems deprecated from citrus side)
######  c) Transaction APIs
 
   1) Add Transaction - Merchant can add transaction using this API
   2) Get One Transaction - Merchant can get transaction details using this API
   3) Get All Transactions - Merchant can get all transaction details using this API
   4) Get Transaction Details - This API will fetch transaction details based on merchant transaction reference number
###### d) Split APIs 
    1) Split Transaction- Merchant can split his transaction between one or multiple sellers and provide details like seller share amount and merchant fee amount for this transaction
    2) Get One Transactions Split - Merchant can query splits performed on a specific transaction
    3) Get All Transactions Split- Merchant can query all splits performed on a specific transaction using this API
    4) Update Transactions Split - Merchant can update his earlier splits using this API, update on splits can be performed only if funds are not released for this transaction
######  e) Merchant APIs
  Get Merchant Account Balance
  
###### f) Settlement API(only needed in development) 

Settlement API(only needed in development and automatic in production mode)
######  g) Get Settlement Status 
######  h) Transactions Release Funds

###### i) Refunds (This section needs more planning)
A refund in a marketplace ecosystem is a `two` step process:
 Case 1) Merchant Refunding the customer who made the payment.
 Case 2) Merchant collecting the refund back from the seller who sold the good/service.
 
 **Case1** is taken care by the regular Payment Gateway Refund API
   Refund API provides functionality to refund the amount of successful transaction
   
 **Case2** (2 posibilities)
  1)already been split , but is either awaiting release/ has already been released.
     A split refund is to be performed on such transaction
      Split Refunds- when a transaction has already been split. This API can be called post payout to sellers too(which will adjust in subsequent payouts)
  2) still un-split in the Citrus Splitpay system.
     A trans refund is to be performed in this scenario. 
      Transaction Refund-called for Refunds when a transaction has not been split yet.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/flyingboy007/citrus_payments. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CitrusPayments project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/flyingboy007/citrus_payments/blob/master/CODE_OF_CONDUCT.md).
