module CitrusPayments
  module Marketplace
    class Authentication
      def self.new_merchant_auth_token

        uri = URI.parse(CitrusPayments.configuration.base_url+'marketplace/auth/')
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        request.body = JSON.dump({
                                     'access_key' => CitrusPayments.configuration.access_key,
                                     'secret_key' => CitrusPayments.configuration.secret_key
                                 })

        req_options = {
            use_ssl: uri.scheme == 'https',
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        JSON.parse(response.body)
      end

    end
  end
end