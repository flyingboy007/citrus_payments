require_relative '../../spec_helper'

describe CitrusPayments::Marketplace::Authentication do
  context "Merchant authentication" do
    it 'fetches auth_token from citrus' do
      VCR.use_cassette("marketplace/merchant/auth_token/success") do
        auth_token=CitrusPayments::Marketplace::Authentication.new_merchant_auth_token
        expect(auth_token).to_not be_nil
        expect(auth_token['error_description']).to be_nil
      end
    end

    it 'unable to fetch auth_token from citrus' do
      VCR.use_cassette("marketplace/merchant/auth_token/failure") do
        CitrusPayments.configuration.access_key="hhhh"
        auth_token=CitrusPayments::Marketplace::Authentication.new_merchant_auth_token
        expect(auth_token['error_description']).to_not be_nil
      end
    end

  end

end