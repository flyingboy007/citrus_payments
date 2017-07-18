require_relative '../../spec_helper'

describe CitrusPayments::Marketplace::Split do
  valid_auth_token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wNy0yM1QxMTo1NzoxMC43NDBaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.3lo5IdaU75fxpNQWxyvKley-J5snq31-CEhXfkM93MI"
  context "create seller" do

    transaction_attributes={
        "trans_id": 105573, #citrus payment trans_id
        "seller_id":3260,
        "merchant_split_ref":"ref",
        "split_amount":12,
        "fee_amount":2,
        "auto_payout":0
    }


    it "creates split" do
      VCR.use_cassette("marketplace/merchant/split/create/success") do
        response=CitrusPayments::Marketplace::Split.create(valid_auth_token, transaction_attributes)
        expect(response[:split_id]).to_not be_nil
      end
    end

    it "returns error if invalid fields" do
      VCR.use_cassette("marketplace/merchant/split/create/invalid") do
        invalid_transaction_attributes=transaction_attributes.clone
        invalid_transaction_attributes[:trans_id]="invalid_trans_id"*4
        response=CitrusPayments::Marketplace::Split.create(valid_auth_token, invalid_transaction_attributes)
        expect(response[:error_description]).to eq("trans_id is not of a type(s) number")
      end
    end

    it "returns error if invalid token" do
      VCR.use_cassette("marketplace/merchant/split/create/failure_token") do
        response=CitrusPayments::Marketplace::Split.create("wrong_auth_token", transaction_attributes)
        expect(response[:error_description]).to eq("Invalid user Token")
      end
    end

    it "returns error if invalid transaction_id" do
      VCR.use_cassette("marketplace/merchant/split/create/failure_invalid_transaction") do
        invalid_transaction_attributes=transaction_attributes.clone
        invalid_transaction_attributes[:trans_id]=333322
        invalid_transaction_attributes[:merchant_split_ref]="djfjdhfjdhfjdbvbvb"
        response=CitrusPayments::Marketplace::Split.create(valid_auth_token, invalid_transaction_attributes)
        expect(response[:error_description]).to eq("Invalid Transaction Id!!!")
      end
    end
  end
end