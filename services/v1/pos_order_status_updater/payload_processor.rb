require_relative 'confirm'
require_relative 'ready'
require_relative 'in_delivery'
require_relative 'deliver'
require_relative 'cancel'
require_relative 'base'

# This class builds the payload to send to a consumer
module V1
  module PosOrderStatusUpdater
    class PayloadProcessor
      CONFIRMED_CALLBACK_ID = 1
      READY_FOR_PICKUP_CALLBACK_ID = 5
      IN_DELIVERY_CALLBACK_ID = 2
      DELIVERED_CALLBACK_ID = 3
      CANCELED_CALLBACK_ID = 4

      def initialize(callback_id:, payload:)
        @callback_id = callback_id
        @payload = payload
      end

      def call
        case @callback_id
        when CONFIRMED_CALLBACK_ID
          Confirm.new(@payload).call
        when READY_FOR_PICKUP_CALLBACK_ID
          Ready.new(@payload).call
        when IN_DELIVERY_CALLBACK_ID
          InDelivery.new(@payload).call
        when DELIVERED_CALLBACK_ID
          Deliver.new(@payload).call
        when CANCELED_CALLBACK_ID
          Cancel.new(@payload).call
        end
      end
    end
  end
end
