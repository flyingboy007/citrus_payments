require_relative '../../spec_helper'

describe CitrusPayments::Marketplace::Settlement do
  valid_auth_token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wNy0yOVQwNzo1MjozNC43NjBaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.5bH5RceSByzwUkbATZadnno7-zffE_Oq-L21OrZnAPA"

  #Only needed in development
  context "create split" do
    settlement_attributes={
        trans_id: 105573,
        settlement_ref: "Ref#CITFAKE",
        trans_source: 'CITRUS',
        settlement_amount: 10,
        fee_amount: 2,
        settlement_date_time: "2017-07-24 13:14:00"
    }
    it "creates settlement" do
      VCR.use_cassette("marketplace/merchant/settlement/create/success") do
        response=CitrusPayments::Marketplace::Settlement.create(valid_auth_token, settlement_attributes)
        expect(response[:settlement_id]).to_not be_nil
      end
    end

    it "returns error if invalid fields" do
      VCR.use_cassette("marketplace/merchant/settlement/create/failure_settlement_amount") do
        settlement_with_invalid_settlement_amount=settlement_attributes.clone
        settlement_with_invalid_settlement_amount[:settlement_amount]="invalid_settlement_number"*4
        response=CitrusPayments::Marketplace::Settlement.create(valid_auth_token, settlement_with_invalid_settlement_amount)
        expect(response[:error_description]).to eq("settlement_amount is not of a type(s) number")
      end
    end

    it "returns error if invalid token" do
      VCR.use_cassette("marketplace/merchant/settlement/create/failure_token") do
        response=CitrusPayments::Marketplace::Settlement.create("wrong_auth_token", settlement_attributes)
        expect(response[:error_description]).to eq("Invalid user Token")
      end
    end

  end
end