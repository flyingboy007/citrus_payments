require_relative '../../spec_helper'

describe CitrusPayments::Marketplace::Transaction do
  valid_auth_token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wNy0yOVQwNzo1MjozNC43NjBaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.5bH5RceSByzwUkbATZadnno7-zffE_Oq-L21OrZnAPA"

  context "Release Payment" do
    split_id=97434
    it "release successfully" do
      VCR.use_cassette("marketplace/merchant/transaction/release/success") do
        response=CitrusPayments::Marketplace::Transaction.release(valid_auth_token, split_id)
        expect(response[:payout]).to eq("true")
      end
    end

    it "returns error if invalid fields" do
      VCR.use_cassette("marketplace/merchant/transaction/release/failure_settlement_amount") do
        split_id="..."
        response=CitrusPayments::Marketplace::Transaction.release(valid_auth_token, split_id)
        expect(response[:error_description]).to eq("split_id is not of a type(s) number")
      end
    end

    it "returns error if invalid token" do
      VCR.use_cassette("marketplace/merchant/transaction/release/failure_token") do
        response=CitrusPayments::Marketplace::Transaction.release("wrong_auth_token", split_id)
        expect(response[:error_description]).to eq("Invalid user Token")
      end
    end

  end


end