require_relative '../../spec_helper'

describe CitrusPayments::Marketplace::Seller do
  context "create seller" do
    seller_attributes= {
        'seller_name' => "Fake_Name",
        'seller_add1' => "Fake_Street",
        'seller_city' => "Fake_City",
        'seller_state' => "Fake_state",
        'seller_country' => 'Fake_country',
        'zip' => "690001",
        'seller_mobile' => "1234567899",
        'seller_ifsc_code' => "ICIC0000010",
        'seller_acc_num' => "Fake_account_number",
        'active' => 1,
        'payoutmode' => 'NEFT',
        'selleremail' => "fake1@gmail.com"
    }

    valid_auth_token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wNy0yMVQwNzowNToxNC42MjJaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.L1BVi_0fx7utnes7FPq4mw_coHGL1QPfSOyqTn93TFE"
    it "creates seller if all fields present" do
      VCR.use_cassette("marketplace/merchant/seller/create/success") do
        response=CitrusPayments::Marketplace::Seller.create(valid_auth_token, seller_attributes)
        expect(response[:sellerid]).to_not be_nil
      end
    end

    it "returns error if invalid fields" do
      VCR.use_cassette("marketplace/merchant/seller/create/failure_zip") do
        invalid_zip_seller=seller_attributes.clone
        invalid_zip_seller[:zip]="invalid_zip_seller"*4
        response=CitrusPayments::Marketplace::Seller.create(valid_auth_token, invalid_zip_seller)
        expect(response[:error_description]).to eq("zip does not meet maximum length of 12")
      end
    end

    it "returns error if invalid token" do
      VCR.use_cassette("marketplace/merchant/seller/create/failure_token") do
        response=CitrusPayments::Marketplace::Seller.create("wrong_auth_token", seller_attributes)
        puts response
        expect(response[:error_description]).to eq("Invalid user Token")
      end
    end
  end
end

