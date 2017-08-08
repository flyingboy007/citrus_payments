module CitrusPayments
  module Marketplace
    module Refunds
      class PgRefund
        def self.create(merchant_auth_token, refund_attributes)
          #changing url based on sandbox/production(this one have a diferent url than others)
          url= CitrusPayments.configuration.base_url.include?("splitpaysbox") ? 'https://sandboxadmin.citruspay.com/api/v2/txn/refund' : 'https://admin.citruspay.com/api/v2/txn/refund'
          uri = URI.parse(url)
          request = Net::HTTP::Post.new(uri)
          request.content_type = 'application/json'
          request['accept']= 'application/json' #else receive xml response
          request['signature']= merchant_auth_token
          request['access_key']= CitrusPayments.configuration.access_key
          request.body = JSON.dump(refund_attributes)

          req_options = {
              use_ssl: uri.scheme == 'https',
          }

          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          #parse xml response
          parsed_response=JSON.parse(response.body, :symbolize_names => true)
          parsed_response
        end
      end
    end
  end
end