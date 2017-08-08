module CitrusPayments
  class Utility
    require 'base64'
    require 'cgi'
    require 'openssl'

    #generate signature
    def self.generate_payment_signature(attributes)
      data=CitrusPayments.configuration.vanity_url + attributes[:orderAmount] + attributes[:merchantTxnId] + attributes[:currency]
      secret=CitrusPayments.configuration.secret_key
      self.hmac_sha1(data, secret)
    end

    #decode signature
    def self.verify_payment_signature(attributes)
      #convert to symbolized hash for consistancy
      symbolised_attributes=Hash[attributes.map {|k, v| [k.to_sym, v]}]

      secret_key=CitrusPayments.configuration.secret_key
      verification_data= symbolised_attributes[:TxId]\
        + symbolised_attributes[:TxStatus]\
        + symbolised_attributes[:amount]\
        + symbolised_attributes[:pgTxnNo]\
        + symbolised_attributes[:issuerRefNo]\
        + symbolised_attributes[:authIdCode]\
        + symbolised_attributes[:firstName]\
        + symbolised_attributes[:lastName]\
        + symbolised_attributes[:pgRespCode]\
        + symbolised_attributes[:addressZip]
      signature=hmac_sha1(verification_data, secret_key)
      #If signature matches the one from citrus true else false (its been tampered)
      if signature==symbolised_attributes[:signature]
        true
      else
        false
      end
    end

    #pg refund signature creation
    def self.generate_pg_refund_signature(refund_attributes)
      data="merchantAccessKey=" + CitrusPayments.configuration.access_key + "&transactionId=" + refund_attributes[:merchantTxnId] + "&amount=" + refund_attributes[:amount];

      secret=CitrusPayments.configuration.secret_key
      self.hmac_sha1(data, secret)
    end

    private
    # helper method for creating hexdigest
    def self.hmac_sha1(data, secret)
      hmac=OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.encode('ASCII'), data.encode('ASCII'))
      return hmac
    end
  end


end