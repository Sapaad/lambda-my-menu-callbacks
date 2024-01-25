require_relative 'base'

module V1
  module PosOrderStatusUpdater
    class Cancel < Base
      CANCELED = 110

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
          puts "Rejecting order: #{@payload[:sapaad_order_id]}"
          send_callback(url, payload, @payload.dig(:partner_order_status_callback_details, "headers"))
        end
      end

      def payload
         {
          "order_id": @payload[:sapaad_order_id],
          "location_id": @payload.dig(:partner_order_status_callback_details, 'location_identifier'),
          "new_status": "rejected",
          "message": "Order rejected",
          "reason_code": rejection_reason
        }
      end

      def rejection_reason
        if @payload[:rejection_reason] == 'Item out of stock'
          'item_out_of_stock'
        elsif @payload[:rejection_reason] == 'Store closed'
          'store_closed'
        elsif @payload[:rejection_reason] == 'Store Busy'
          'store_busy'
        elsif @payload[:rejection_reason] == 'Rider not available'
          'rider_not_available'
        elsif @payload[:rejection_reason] == 'Out of delivery radius'
          'out_of_delivery_radius'
        elsif @payload[:rejection_reason] == 'Connectivity issue'
          'connectivity_issue'
        elsif @payload[:rejection_reason] == 'Total mismatch'
          'total_missmatch'
        elsif @payload[:rejection_reason] == 'Invalid Item'
          'invalid_item'
        elsif @payload[:rejection_reason] == 'Option out of stock'
          'option_out_of_stock'
        elsif @payload[:rejection_reason] == 'Invalid option'
          'invalid_option'
        else
          'unspecified'
        end
      end
    end
  end
end
