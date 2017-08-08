require_relative '../spec_helper'

describe CitrusPayments::Utility do
  context "payment creation" do
    it "generates a valid signature for sending to citrus" do
      attributes = {
          orderAmount: '27',
          merchantTxnId: '5432',
          currency: 'inr'
      }
      data=CitrusPayments.configuration.vanity_url + attributes[:orderAmount] + attributes[:merchantTxnId] + attributes[:currency]
      signature = hmac_sha1(data, CitrusPayments.configuration.secret_key)
      expect(signature).to eq(CitrusPayments::Utility.generate_payment_signature(attributes))
    end

    it "returns true if signature valid" do
      payment_response = {
          TxId: '388383',
          TxStatus: 'success',
          amount: '27',
          pgTxnNo: 'ee',
          issuerRefNo: '5432',
          authIdCode: '39393939',
          firstName: 'test',
          lastName: 'user',
          pgRespCode: '22222',
          addressZip: '399333',
          signature: '19b82cc6ff83fc8962a25c8dca64151978dd21b6'
      }


      response=CitrusPayments::Utility.verify_payment_signature(payment_response)

      expect(response).to eq(true)

    end

    it "returns false if signature tampered" do
      payment_response = {
          TxId: '388383',
          TxStatus: 'success',
          amount: '27',
          pgTxnNo: 'ee',
          issuerRefNo: '5432',
          authIdCode: '39393939',
          firstName: 'test',
          lastName: 'user',
          pgRespCode: '22222',
          addressZip: '399333',
          signature: '_tampered_signature'*4
      }

      response=CitrusPayments::Utility.verify_payment_signature(payment_response)
      expect(response).to eq(false)
    end
  end

  context "PgRefund signature creation" do
    it "generates a valid refund signature for sending to citrus" do
      refund_attributes={
          merchantTxnId: "RD-0320837687",
          pgTxnId: "6789994221172191",
          rrn: "7219386355",
          authIdCode: "999999",
          currencyCode: "INR",
          amount: "12",
          txnType: "Refund"
      }

      data="merchantAccessKey=" + CitrusPayments.configuration.access_key + "&transactionId=" + refund_attributes[:merchantTxnId] + "&amount=" + refund_attributes[:amount];
      valid_refund_signature=hmac_sha1(data, CitrusPayments.configuration.secret_key)
      expect(valid_refund_signature).to eq(CitrusPayments::Utility.generate_pg_refund_signature(refund_attributes))
    end

  end

end