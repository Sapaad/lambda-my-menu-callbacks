require 'json'

require_relative 'services/v1/pos_order_status_updater/payload_processor'

# Entry point from API Gateway
def lambda_handler(event:, context:)
  puts "Event received: #{event}"
  
  if !event['callback_id'].nil?
    event.transform_keys!(&:to_sym)
    event[:payload].transform_keys!(&:to_sym)

    result = V1::PosOrderStatusUpdater::PayloadProcessor.new(callback_id: event[:callback_id],
                                  payload: event[:payload]).call

    { status: 'success', code: 200, callbacks: [result] }
  else
    puts "Event not watched"
    { status: 'success', code: 200 }
  end
end

# event = {
#     "callback_id" => 1,
#     "callback_title" => "Order Confirmed",
#     "category" => "ORDER",
#     "timestamp" => "sample time stamp",
#     "payload" => {
#       "order_source" => "deliveroo",
#       "remote_order_id" => "999",
#       "sapaad_order_id" => "25",
#       "delivery_time" => 20,
#       "prep_time" => 40
#     }
#   }
# lambda_handler(event: event, context: {})
