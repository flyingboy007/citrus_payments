require_relative '../../../spec_helper'

describe CitrusPayments::Marketplace::Refunds::PgRefund do

  context 'Release Payment' do
    refund_attributes={
        merchantTxnId: "RD-0320837687",
        pgTxnId: "6789994221172191",
        rrn: "7219386355",
        authIdCode: "999999",
        currencyCode: "INR",
        amount: "12",
        txnType: "Refund"
    }

    it 'returns error if invalid token' do
      VCR.use_cassette('marketplace/refunds/pg_refund/failure_token') do
        response=CitrusPayments::Marketplace::Refunds::PgRefund.create('wrong_auth_token', refund_attributes)
        expect(response[:respMsg]).to eq('Bad Request:Invalid signature key')
      end
    end

    it 'returns success if refunded' do
      valid_signature=CitrusPayments::Utility.generate_pg_refund_signature(refund_attributes)
      VCR.use_cassette('marketplace/refunds/pg_refund/success') do
        response=CitrusPayments::Marketplace::Refunds::PgRefund.create(valid_signature, refund_attributes)
        expect(response[:respMsg]).to eq("Transaction successful")
      end
    end

    it "returns error if invalid fields" do
      VCR.use_cassette("marketplace/refunds/pg_refund/invalid_trans_id") do
        altered_trans_id=refund_attributes.clone
        altered_trans_id['merchantTxnId']="..."
        new_signature= CitrusPayments::Utility.generate_pg_refund_signature(altered_trans_id)

        response=CitrusPayments::Marketplace::Refunds::PgRefund.create(new_signature, altered_trans_id)
        expect(response[:respMsg]).to eq("Bad Request:Invalid signature key")
        puts response

      end
    end

  end
end