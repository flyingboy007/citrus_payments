module CitrusPayments
  module Marketplace
    module Refunds
      class PgRefund
        require 'nokogiri'

        def self.create(merchant_auth_token, refund_attributes)
          #changing url based on sandbox/production(this one have a diferent url than others)
          url= CitrusPayments.configuration.base_url.include?("splitpaysbox") ? 'https://sandboxadmin.citruspay.com/api/v2/txn/refund' : 'https://admin.citruspay.com/api/v2/txn/refund'
          uri = URI.parse(url)
          request = Net::HTTP::Post.new(uri)
          request.content_type = 'application/json'
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
          response = Nokogiri::XML(response.body)
          response_status=response.xpath('//respMsg/text()').to_s

          #on success parent node is 'refundResponse' otherwise its 'response'
          #based on parent node name get attributes
          if (response_status=="Transaction successful")
            parsed_response = response.xpath("//refundResponse/*").each_with_object({}) do |node, hash|
              hash[node.name] = node.text
            end
          else
            parsed_response = response.xpath("//response/*").each_with_object({}) do |node, hash|
              hash[node.name] = node.text
            end
          end

          #symbolise for consistency
          parsed_response=parsed_response.inject({}) {|h, (k, v)| h.merge({k.to_sym => v})}
          parsed_response
        end
      end
    end
  end
end