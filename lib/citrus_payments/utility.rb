module CitrusPayments
  class Utility
    require 'base64'
    require 'cgi'
    require 'openssl'

    #generate signature
    def self.generate_signature(attributes)
      data=CitrusPayments.configuration.vanity_url + attributes[:orderAmount] + attributes[:merchantTxnId] + attributes[:currency]
      secret=CitrusPayments.configuration.secret_key
      self.hmac_sha1(data, secret)
    end

    #decode signature
    def self.verify_signature(attributes)
      secret_key=CitrusPayments.configuration.secret_key
      verification_data= attributes[:tx_id]\
        + attributes[:tx_status]\
        + attributes[:amount]\
        + attributes[:pgTxnNo]\
        + attributes[:issuer_ref_no]\
        + attributes[:auth_id_code]\
        + attributes[:first_name]\
        + attributes[:last_name]\
        + attributes[:pg_resp_code]\
        + attributes[:address_zip]
      signature=hmac_sha1(verification_data, secret_key)
      #If signature matches the one from citrus true else false (its been tampered)
      if signature==attributes[:signature]
        true
      else
        false
      end
    end

    private
    # helper method for creating hexdigest
    def self.hmac_sha1(data, secret)
      hmac=OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.encode('ASCII'), data.encode('ASCII'))
      return hmac
    end
  end


end