# CitrusPayments [![Build Status](https://travis-ci.org/flyingboy007/citrus_payments.svg?branch=master)](https://travis-ci.org/flyingboy007/citrus_payments) [![Coverage Status](https://coveralls.io/repos/github/flyingboy007/citrus_payments/badge.svg?branch=master)](https://coveralls.io/github/flyingboy007/citrus_payments?branch=master)
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

In the initialiser add authkey:

Below info can be found on citrus dashboard

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

### PAYMENT MAKING

  **Generate signature for making payment**
         
  Send payment details like this to `generate a signature`     
  

      payment_details = {
               orderAmount: '27',
               merchantTxnId: 'unique_merchant_txn_id',
               currency: 'inr'
           }
       
 ` CitrusPayments::Utility.generate_payment_signature(payment_details)`
 

  
  **Decode signature**
  
  send response from citrus to verify the signature
   
  `CitrusPayments::Utility.verify_payment_signature(payment_response)`
        Returns `true` or `false`
     If `true` proceeds with processing else if `false` the request is tampered and should not continue processing


### SPLITPAY(Marketplace)

####  **a) User Authentication**
 This API authenticates the `Merchant` and returns an `auth_token`. This token is a mandatory parameter in the header and is required to run any subsequent APIs of Marketplace system.
    

    CitrusPayments::Marketplace::Authentication.new_merchant_auth_token

---

    
    ##success response  {"auth_token"=>"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wNy0yMFQxMDo0MToyMy4zNjJaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.W_LhFZl-h9F5j3NhH3os3zEi8BNRkXl3MnwniveHRb4"}
    
    ##error response
    {"error_id"=>"0", "error_category"=>"application", "error_description"=>"Invalid user"}


####  **b) Seller API** 
   **1)Create - Merchant can on board his sellers**
  

    seller_attributes={
                'seller_name' => "Fake_Name",
                'seller_add1' => "Fake_Street",
                'seller_city' => "Fake_City",
                'seller_state' => "Fake_state",
                'seller_country' => 'Fake_country',
                'zip' => "690001",
                'seller_mobile' => "1234567899",
                'seller_ifsc_code' => "ICIC0000011",
                'seller_acc_num' => "Fake_account_number",
                'active' => 1,
                'payoutmode' => 'NEFT',
                'selleremail' => "fake1@gmail.com"
                }
          CitrusPayments::Marketplace::Seller.create(auth_token, seller_attributes)

--------

    ##success_response
    {:sellerid=>3260}
    
    ##failure_response
    
    {:error_id=>"4", :error_category=>"application", :error_description=>"Invalid user Token"}



   **2)Update  - Merchant can update existing sellers**

    seller_attributes={
                'seller_name' => "Fake_Name",
                'seller_add1' => "Fake_Street",
                'seller_city' => "Fake_City",
                'seller_state' => "Fake_state",
                'seller_country' => 'Fake_country',
                'zip' => "690001",
                'seller_mobile' => "1234567899",
                'seller_ifsc_code' => "ICIC0000011",
                'seller_acc_num' => "Fake_account_number",
                'active' => 1,
                'payoutmode' => 'NEFT',
                'selleremail' => "fake1@gmail.com",
                'seller_id' => 3260
            }
        
        CitrusPayments::Marketplace::Seller.create(auth_token, seller_attributes)


--------

    
    ##success_response
    {:sellerid=>3260, :status=>"success"}
    
    ##failure_response
    
    {:error_id=>"4", :error_category=>"application", :error_description=>"Invalid user Token"}



   **3)Get Seller - Merchant can get existing seller details**

    seller_id=3260
    
    CitrusPayments::Marketplace::Seller.get_seller(auth_token, seller_id)

--------

    ##success_response
    
    {"seller_id":3260,"seller_name":"Fake_Name","seller_add1":"Fake_Street","seller_add2":"","seller_city":"Fake_City","seller_state":"Fake_state","seller_country":"Fake_country","seller_zip":"690001","business_url":"undefined","selleremail":"fake1@gmail.com","seller_ifsc_code":"ICIC0000011","seller_acc_num":"Fake_account_number","payoutmode":"NEFT","seller_account_id":4699,"seller_active":1,"seller_mobile":"1234567899","seller_mobile_verified":0,"sms_notify":0,"seller_email_verified":0,"email_notify":0,"kyc_status":0,"is_international":0,"currency":"INR"}
    
    ##failure_response
    
    {:error_id=>"210", :error_category=>"application", :error_description=>"No
        sellers found!!!"}



   **4)Get All Sellers - Merchant can get all the existing seller details created by him**
    

    CitrusPayments::Marketplace::Seller.get_all_sellers(auth_token)

--------

     
    
       ##success_response
            
            [{
        "seller_id": 463,
        "seller_name": "Smith Taylor",
        "seller_add1": "City Light",
        "seller_add2": "Link Road",
        "seller_city": "Mumbai",
        "seller_state": "MH",
        "seller_country": "India",
        "seller_zip": "41234",
        "business_url": "test@test.com",
        "selleremail": "smithtaylor@gmail.com",
        "seller_ifsc_code": "ICIC0001469",
        "seller_acc_num": "00225367",
        "payoutmode": "NEFT",
        "seller_account_id": 71,
        "seller_active": "1"
        }
        {
        "seller_id": 464,
        "seller_name": "John Smith",
        "seller_add1": "City Garden",
        "seller_add2": "Link Road",
        "seller_city": "Mumbai",
        "seller_state": "MH",
        "seller_country": "India",
        "seller_zip": "41234",
        "business_url": "test@test.com",
        "selleremail": "johnsmith@gmail.com",
        "seller_ifsc_code": "ICIC0001206",
        "seller_acc_num": "123456",
        "payoutmode": "WALLET",
        "seller_account_id": 72,
        "seller_active": "1"
        }]
            
     ##failure_response
            
    {"error_id":"4","error_category":"application","error_description":"Invalid_user Token"}


 **d) Split APIs**

   **1) Split Transaction:** *Merchant can split his transaction between one or multiple sellers and provide details like seller share amount and merchant fee amount for this transaction*
   
    transaction_attributes={
        "trans_id": 105573, #citrus payment trans_id
        "seller_id":3260,
        "merchant_split_ref":"ref",
        "split_amount":12,
        "fee_amount":2,
        "auto_payout":0
    }
        CitrusPayments::Marketplace::Split.create(auth_token, transaction_attributes)


--------

    
    ##success_response
        
        {"split_id":92437,"trans_id":105573,"merchant_split_ref":"ref"}
        
    ##failure_response
        
    {"error_id":"313","error_category":"application","error_description":"Invalid
            Transaction Id!!!"}
            
   4) **Update Transactions Split** - *Merchant can update his earlier splits using this API, update on splits can be performed only if funds are not released for this transaction*  

    transaction_update_attributes={
        "split_id": 92437,
        "seller_id": 3260,
        "merchant_split_ref": "ref",
        "split_amount": 12,
        "fee_amount": 4,
        "auto_payout": 0
    }

        CitrusPayments::Marketplace::Split.update(auth_token, transaction_update_attributes)


--------

    
    ##success_response
        
    {"split_id":92437,"changedRows":1}
        
    ##failure_response
        
    {"error_id":"330","error_category":"application","error_description":"Invalid
        Split Id!!!"}
    
    
   **2) Get One Transactions Split** - *Merchant can query splits performed on a specific transaction*

    split_id=3260
    
    CitrusPayments::Marketplace::Seller.get_split(auth_token, split_id)

--------

     ##success_response
        
        {"split_id":92437,"trans_id":105573,"seller_id":3260,"merchant_split_ref":"ref","split_amount":11,"fee_amount":1,"auto_payout":0,"req_datetime":"2017-07-18T18:10:25.000Z","fundReleased":[],"refunds":[]}
        
     ##failure_response
        
    {"error_id":"322","error_category":"application","error_description":"No
            split information found!!!"}

 

**e) Merchant APIs**
----------------
**Get Merchant Account Balance**-  *Merchant can query his balance*

       CitrusPayments::Merchant.get_balance(auth_token)

--------

     success_response
        
      {"account_id":3173,"account_balance":3680}
        
     failure_response
     
    {"error_id":"4","error_category":"application","error_description":"Invalid user Token"}

**f) Settlement API(only needed in development)**

*Settlement API(only needed in development as this is done by citrus in production mode)*
     
 You don’t have to call this API on live environment as this is automatically supposed to Run before T+1 (5.00 pm) timeframe, where T is the day of transaction. 
 
 *You can only release funds once settlement is successfully run.*

    settlement_attributes={
        trans_id: 105573,
        settlement_ref: "Ref#CITFAKE",
        trans_source: 'CITRUS',
        settlement_amount: 10,
        fee_amount: 2,
        settlement_date_time: "2017-07-24 13:14:00"
    }   
    CitrusPayments::Marketplace::Settlement.create(auth_token, settlement_attributes)

--------

     ##success_response
        
      {"settlement_id":38268,"trans_id":105573}
        
     ##failure_response
     
    {"error_id":"7","error_category":"application","error_description":"settlement_amount is not of a type(s) number"}


 **g) Get Settlement Status** 

*Before releasing funds against any split created it is important that the settlement has happened on that transaction*

 *For enquiring whether a split is ready to release, you can call this method and if settlement_id is returned it means you are good to release funds against the split/splits under that transaction.*

     trans_id=110696  
     
     CitrusPayments::Marketplace::Settlement.get_status(auth_token, trans_id)

--------

     ##success_response
        
      {"settlement_id":38273,"trans_id":110696,"settlement_ref":"5821744918","trans_source":"CITRUS","settlement_amount":11,"fee_amount":1,"settlement_date_time":"24/07/2017
        17:10:18","req_date_time":"24/07/2017 17:10:20"}
        
     ##failure_response
     
    {"error_id":"518","error_category":"application","error_description":"No
        settlement details found for this transaction!!!"}

 **h) Transactions Release Funds**
 
*Funds are released based on the respective split_id*

     split_id=97434
            CitrusPayments::Marketplace::Transaction.release(auth_token, split_id)

--------

     ##success_response
        
      {"releasefund_ref":37267,"trans_id":110696,"split_id":97434,"seller_id":2153,"amount":11,"payoutmode":"NEFT","payout":"true"}
        
     ##failure_response
     
    {"error_id":"7","error_category":"application","error_description":"split_id is not of a type(s) number"}


###### **i) Refunds** 
A refund in a marketplace ecosystem is a `two` step process:
 
 **Case 1)** Merchant Refunding the customer who made the payment(Payment Gateway Refund).
 
 **Case 2)** Merchant collecting the refund back from the seller who sold the good/service.
 
 **Payment Gateway Refund**  (mandatory for all usecases)
 
  _Merchant Refunding the customer who made the payment_


       transaction_attributes={
        merchantTxnId: "RD-0320837687",
        pgTxnId: "6789994221172191",
        rrn: "7219386355",
        authIdCode: "999999",
        currencyCode: "INR",
        amount: "12",
        txnType: "Refund"
    }
    
    ##signature generation
    #generate_pg_refund_signature
   
    ##either send transaction_attributes hash above or be specific like below (for signature generation) 
    signature=CitrusPayments::utility.generate_pg_refund_signature({merchantTxnId: "RD-0320837687", amount: "12"})
   
    ##send request response=CitrusPayments::Marketplace::Refunds::PgRefund.create(signature, transaction_attributes)



--------

     ##success_response
        
      {:amount=>"12.0", :authIdCode=>"999999", :currency=>"INR", :merchantRefundTxId=>"CRX1708071356364540978", :merchantTxnId=>"RD-0320837687", :paymentId=>"-1", :pgTxnId=>"429630291972191", :RRN=>"721917222533", :respCode=>"0", :respMsg=>"Transaction successful", :transactionId=>"RD-0320837687"}

        
     ##failure_response
     
    {:noOfTxnsToDisplay=>"0", :respCode=>"401", :respMsg=>"Bad Request:Invalid signature key", :totalTxnCount=>"0"}
    
**Splitpay Refunds** _(only needed if using splitpay)_

 _If using splitpay call either one below after calling Payment Gateway Refund._
 
 **Two posibilities for splitpay**
  
  1)already been `split` , but is either awaiting release/ has already been released.
     A `split refund` is to be performed on such transaction
      `Split Refunds`- when a transaction has already been split. This API can be called post payout to sellers too(which will adjust in subsequent payouts)
  2) still `un-split` in the Citrus Splitpay system.
     A `trans refund` is to be performed in this scenario. 
      `Transaction Refund`-called for Refunds when a transaction has `not` been `split` yet.
    
 **Transaction Refund**(optional)
 _
 For Refunds when a transaction has not been split yet_


    transaction_attributes={
        trans_id: 114413,
        refund_amount: 6,
        refund_ref: 'RD-6191651979_Refund',
        pg_refund_charge: 0,
        refund_datetime: '2017-08-09 12:00:28'
    }
    
    ##send request 
    response=CitrusPayments::Marketplace::Refunds::TransRefund.create(transaction_attributes)



--------

     ##success_response
        
    {"refund_id":31431,"trans_id":114413,"refund_amount":6}
        
     ##failure_response
     
    {"error_id":"7","error_category":"application","error_description":"trans_id is not of a type(s) number"}


**Split Refund**(optional)

 *For Refunds when a transaction has not been split yet*


    transaction_attributes={
        split_id:101126,
        refund_ref:"RD-4292297693",
        pg_refund_charge:0,
        refund_datetime:"2017-08-08 2:33:00"
    }
    
    ##send request 
    response=CitrusPayments::Marketplace::Refunds::SplitRefund.create(transaction_attributes)



--------

     ##success_response
        
    {"refund_id":31464,"trans_id":114443,"split_id":101126,"refund_amount":6}
        
     ##failure_response
     
    {"error_id":"7","error_category":"application","error_description":"split_id is not of a type(s) number"}





TODO: Planned features(**Below features are planned and will be added as implemented**)


      

### SPLITPAY
######  b) Seller API 
   5)Get Seller Account Balance(seems deprecated from citrus side and of no use)
######  c) Transaction APIs(only needed to call when using another payment gateway for making transaction)
 
   1) Add Transaction - Merchant can add transaction using this API
   2) Get One Transaction - Merchant can get transaction details using this API
   3) Get All Transactions - Merchant can get all transaction details using this API
   4) Get Transaction Details - This API will fetch transaction details based on merchant transaction reference number
###### d) Split APIs 

   3) Get All Transactions Split- Merchant can query all splits performed on a specific transaction using this API


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/flyingboy007/citrus_payments. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CitrusPayments project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/flyingboy007/citrus_payments/blob/master/CODE_OF_CONDUCT.md).

