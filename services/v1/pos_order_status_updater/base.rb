require 'net/http'
require 'json'
module V1
  module PosOrderStatusUpdater
    class Base
      private

      def send_callback(callback_url, payload, headers)
        url = URI(callback_url)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Put.new(url)
        # headers.each { |key, value| request[key] = value }
        request["Content-Type"] = "application/json"
        puts "header #{headers['name']} - #{headers['value']}"
        request[headers['name']] = headers['value']
        request.body = payload.to_json
        res = https.request(request)
        puts "Response: #{res.body} - #{res.code} - request payload: #{payload.to_json}"
        {
          url: callback_url,
          headers: headers,
          body: payload,
          status_from_partner: res.code.to_i == 200,
          message: res.body
        }
      rescue => e
        puts "Sending callback failed - #{e}"
        {
          url: callback_url,
          headers: headers,
          body: payload,
          status_from_partner: false,
          message: 'Failed'
        }
      end
    end
  end
end
