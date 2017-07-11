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

    it "decode a valid signature"
  end
  
  private
  #helper method
  def hmac_sha1(data, secret)
    require 'base64'
    require 'cgi'
    require 'openssl'
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.encode('ASCII'), data.encode('ASCII'))
    return hmac
  end

end