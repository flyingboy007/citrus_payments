#helper method for making digest
def hmac_sha1(data, secret)
  require 'base64'
  require 'cgi'
  require 'openssl'
  hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.encode('ASCII'), data.encode('ASCII'))
  return hmac
end