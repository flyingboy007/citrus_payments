module CitrusPayments
  module Marketplace
    require 'net/http'
    require 'uri'
    require 'json'
    class Seller
      def self.create(merchant_auth_token, seller_attributes)
        uri = URI.parse(CitrusPayments.configuration.base_url+'marketplace/seller/')
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        request['Auth_token']= merchant_auth_token
        request.body = JSON.dump(seller_attributes)

        req_options = {
            use_ssl: uri.scheme == 'https',
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        parsed_response=JSON.parse(response.body, :symbolize_names => true)
        #If input errors response will be in array in weird format
        if parsed_response.is_a?(Array)
          parsed_response.first[:property].slice!("instance.") #removes instance. string from response
          #making a response similar to other errors
          altered_response={error_id: "7", error_category: "stack", error_description: parsed_response.first[:property]+" "+parsed_response.first[:message]}
        else
          parsed_response
        end
      end

      def self.update(merchant_auth_token, seller_attributes)
        uri = URI.parse(CitrusPayments.configuration.base_url+'marketplace/seller/')
        request = Net::HTTP::Put.new(uri)
        request.content_type = 'application/json'
        request['Auth_token']= merchant_auth_token
        request.body = JSON.dump(seller_attributes)
        req_options = {
            use_ssl: uri.scheme == 'https',
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        parsed_response=JSON.parse(response.body, :symbolize_names => true)

        #If input errors response will be in array in weird format
        if parsed_response.is_a?(Array)
          parsed_response.first[:property].slice!("instance.") #removes instance. string from response
          #making a response similar to other errors
          altered_response={error_id: "7", error_category: "stack", error_description: parsed_response.first[:property]+" "+parsed_response.first[:message]}
        else
          parsed_response
        end
      end


      def self.get_seller(merchant_auth_token, seller_id)
        uri = URI.parse(CitrusPayments.configuration.base_url+"marketplace/seller/#{seller_id}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri)
        request["cache-control"] = 'no-cache'
        request["auth_token"] = merchant_auth_token
        request["content-type"] = 'application/json'
        response = http.request(request)
        JSON.parse(response.body, :symbolize_names => true)
      end

      def self.get_all_sellers(merchant_auth_token)
        uri = URI.parse(CitrusPayments.configuration.base_url+"marketplace/seller/")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri)
        request["cache-control"] = 'no-cache'
        request["auth_token"] = merchant_auth_token
        request["content-type"] = 'application/json'
        response = http.request(request)
        JSON.parse(response.body, :symbolize_names => true)
      end

    end
  end
end