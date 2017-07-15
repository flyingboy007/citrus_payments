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
      expect(signature).to eq(CitrusPayments::Utility.generate_signature(attributes))
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


      response=CitrusPayments::Utility.verify_signature(payment_response)

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

      response=CitrusPayments::Utility.verify_signature(payment_response)
      expect(response).to eq(false)
    end
  end

  private
  #helper method for making digest
  def hmac_sha1(data, secret)
    require 'base64'
    require 'cgi'
    require 'openssl'
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.encode('ASCII'), data.encode('ASCII'))
    return hmac
  end
end