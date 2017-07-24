module CitrusPayments
  class Merchant
    def self.get_balance(auth_token)
      uri = URI.parse(CitrusPayments.configuration.base_url+"marketplace/merchant/getbalance/")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri)
      request["cache-control"] = 'no-cache'
      request["auth_token"] = auth_token
      request["content-type"] = 'application/json'
      response = http.request(request)
      JSON.parse(response.body, :symbolize_names => true)
    end
  end
end