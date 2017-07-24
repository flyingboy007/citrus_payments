require_relative '../spec_helper'

describe CitrusPayments::Merchant do
  valid_auth_token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wNy0yM1QxMTo1NzoxMC43NDBaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.3lo5IdaU75fxpNQWxyvKley-J5snq31-CEhXfkM93MI"

  it "gets merchant_balance" do
    VCR.use_cassette("marketplace/merchant/get_balance/success") do
      response=CitrusPayments::Merchant.get_balance(valid_auth_token)
      expect(response[:account_balance]).not_to be nil
    end
  end

  it "returns error if invalid token" do
    VCR.use_cassette("marketplace/merchant/get_balance/failure_invalid_token") do
      response=CitrusPayments::Merchant.get_balance("wrong_auth_token")
      expect(response[:error_description]).to eq("Invalid user Token")
    end
  end
end