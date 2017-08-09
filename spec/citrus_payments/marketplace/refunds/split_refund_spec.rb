require_relative '../../../spec_helper'

describe CitrusPayments::Marketplace::Refunds::SplitRefund do
  valid_auth_token='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wOC0xMlQwNToyNTowNS42NTFaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.jhghjtqWczvGhZAU1Z8zpNPiZZc5aIY7MyafkenZ-u8'

  context 'Release Payment' do
    refund_attributes={
        split_id:101126,
        refund_ref:"RD-4292297693",
        pg_refund_charge:0,
        refund_datetime:"2017-08-08 2:33:00"
    }
    it 'returns error if invalid token' do
      VCR.use_cassette('marketplace/refunds/split_refund/failure_token') do
        response=CitrusPayments::Marketplace::Refunds::SplitRefund.create('wrong_auth_token', refund_attributes)
        expect(response[:error_description]).to eq('Invalid user Token')
      end
    end

    it 'returns success if refunded' do
      VCR.use_cassette('marketplace/refunds/split_refund/success') do
        response=CitrusPayments::Marketplace::Refunds::SplitRefund.create(valid_auth_token, refund_attributes)
        expect(response[:refund_id]).not_to be_nil
      end
    end

    it "returns error if invalid fields" do
      VCR.use_cassette("marketplace/refunds/split_refund/invalid_trans_id") do
        altered_split_id=refund_attributes.clone
        altered_split_id['split_id']="..."
        response=CitrusPayments::Marketplace::Refunds::SplitRefund.create(valid_auth_token, altered_split_id)
        expect(response[:error_description]).to eq("split_id is not of a type(s) number")
      end
    end

  end


end