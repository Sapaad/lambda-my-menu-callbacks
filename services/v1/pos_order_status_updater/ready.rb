require_relative 'base'

module V1
  module PosOrderStatusUpdater
    class Ready < Base
      def initialize(payload)
        @payload = payload
      end

      def call
        if @payload.dig(:partner_order_status_callback_details, "order_status_webhook_url").nil?
          puts "No callback URL configured, payload: #{@payload}"
          {
            url: "",
            headers: "headers",
            body: payload,
            status_from_partner: false,
            message: 'NO URL configured'
          }
        else
          url = "#{@payload.dig(:partner_order_status_callback_details, "order_status_webhook_url")}".freeze
          puts "Order ready: #{@payload[:sapaad_order_id]}"
          send_callback(url, payload, @payload.dig(:partner_order_status_callback_details, "headers"))
        end
      end

      def payload
        {
          "order_id": @payload[:sapaad_order_id],
          "location_id": @payload.dig(:partner_order_status_callback_details, 'location_identifier'),
          "new_status": "ready",
          "message": "Order Prepared"
        }
      end
    end
  end
end
