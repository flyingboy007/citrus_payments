require_relative '../../../spec_helper'

describe CitrusPayments::Marketplace::Refunds::TransactionRefund  do
  valid_auth_token='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiMURZUUk4UzVFRTVVTTk3QUpZS0EiLCJleHBpcmVzIjoiMjAxNy0wOC0xMlQwNToyNTowNS42NTFaIiwiY2FuX3RyYW5zYWN0IjoxLCJhZG1pbiI6MH0.jhghjtqWczvGhZAU1Z8zpNPiZZc5aIY7MyafkenZ-u8'

  context 'Release Payment' do
refund_attributes={
    'trans_id':114126,
    'refund_amount':12,
    'refund_ref':'RD-0320837687_Refund',
    'pg_refund_charge':0,
    'refund_datetime':'2017-08-07 12:20:28'
}
    it 'returns error if invalid token' do
      VCR.use_cassette('marketplace/refunds/transaction_refund/failure_token') do
        response=CitrusPayments::Marketplace::Refunds::TransactionRefund.create('wrong_auth_token', refund_attributes)
        expect(response[:error_description]).to eq('Invalid user Token')
      end
    end

it 'returns success if refunded' do
  VCR.use_cassette('marketplace/refunds/transaction_refund/success') do
    response=CitrusPayments::Marketplace::Refunds::TransactionRefund.create(valid_auth_token, refund_attributes)
    expect(response[:refund_id]).not_to be_nil
  end
end

it "returns error if invalid fields" do
  VCR.use_cassette("marketplace/refunds/transaction_refund/invalid_trans_id") do
    altered_trans_id=refund_attributes.clone
    altered_trans_id['trans_id']="..."
    response=CitrusPayments::Marketplace::Refunds::TransactionRefund.create(valid_auth_token, altered_trans_id)
    expect(response[:error_description]).to eq("trans_id is not of a type(s) number")
  end
end

  end


end