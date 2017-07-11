module CitrusPayments
  class Utility
    require 'base64'
    require 'cgi'
    require 'openssl'

    #generate signature
    def self.generate_signature(attributes)
      data=CitrusPayments.configuration.vanity_url + attributes[:orderAmount] + attributes[:merchantTxnId] + attributes[:currency]
      secret=CitrusPayments.configuration.secret_key
      signature=self.hmac_sha1(data, secret)
      signature
    end

    private
    # helper method for creating hexdigest
    def self.hmac_sha1(data, secret)
      hmac=OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.encode('ASCII'), data.encode('ASCII'))
      return hmac
    end
  end


end