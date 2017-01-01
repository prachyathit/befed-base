module TookanApiService
	require 'rest_client'
	class << self
		TOOKAN_API_URL = 'https://api.tookanapp.com:8888'

		def create_pickup_and_delivary_task user, cart, order
			restaurant = Restaurant.find(order.rest_id)
			shipping_address = order.shipping_address
			payment_type = order.payment_type ? "COD" : "Credit Card"
			dtime = restaurant.dtime
			order_rows = "ออเดอร์หมายเลข #{order.id} \n"
			cart.each do |id, order_info|
				food_id = order_info[:food_id]
				food = Food.find(food_id)
				quantity = order_info[:quantity]
				special = order_info["special"]
				options = order_info["options"]
				order_rows += "#{food.name} x#{quantity} \n"
				#option start
				unless options.nil? 
			  	options.each do |option| 
			    	option_value_id = option[1]["option_value_ids"] 
			      unless option_value_id.first.empty? 
			
				      # <!--Radio button-->
				      if option_value_id.class == String 
				      	option_value = OptionValue.find(option_value_id) 
				      	order_rows += "- #{option_value.name} \n"
				  
				      # <!--Checkbox-->
				      else 
				      	option_value_id.each do |option_number| 
				        	unless option_number.empty? 
				          	option_value = OptionValue.find(option_number) 
				          	order_rows += "- #{option_value.name} \n"
				        	end 
				        end 
				      end 
				  	end 
			    end 
			  end
			  #option end
		    unless special.empty?
		    	order_rows += "- #{special} \n"
		    end
      end 

			headers = {
				:content_type => 'application/json'
			}

			params = {
				access_token: ENV['tookan_api_key'],
				team_id: ENV['tookan_team_id'],
				auto_assignment: "0", # 1 for auto assign, 0 otherwise
				has_pickup: "1",
				has_delivery: "1",
				layout_type: "0",
				tracking_link: 1,
				timezone: "+420", #UTC+7
				fleet_id: "", # assign task to specific agent id (incase auto assign is off)
				p_ref_images: [],
				ref_images: [],
				notify: 1,
				geofence: 0,

				# pickup info
				job_description: order_list,
				job_pickup_phone: restaurant.phone,
				job_pickup_name: restaurant.name,
				job_pickup_email: restaurant.email,
				job_pickup_address: restaurant.address,
				job_pickup_latitude: restaurant.latitude,
				job_pickup_longitude: restaurant.longitude,
				job_pickup_datetime: (DateTime.current + 15.minutes).to_s(:db), #YYYY-MM-DD HH:MM:SS

				# pickup_custom_field_template: "Pickup",
				# pickup_meta_data: [
				# 	{
				# 		label: "Order",
				# 		data: order.id
				# 	}
				# ],

				# delivery info				
				customer_email: user.email,
				customer_username: user.name,
				customer_phone: user.phone,

				customer_address: shipping_address.address,

				latitude: shipping_address.latitude,
				longitude: shipping_address.longitude,

				job_delivery_datetime: (DateTime.current + dtime.minutes).to_s(:db), #YYYY-MM-DD HH:MM:SS
				custom_field_template: "Delivery",
				meta_data: [
					{
						label: "DeliveryInstruction",
						data: shipping_address.instruction
					},
					{
						label: "Phone",
						data: user.phone
					},
					{
						label: "Payment",
						data: payment_type
					},
					{
						label: "Price",
						data: order.total.to_s
					}
				]
			}

			response = RestClient.post TOOKAN_API_URL+'/create_task', params.to_json, headers
			response = JSON.parse(response)
			if response['status'] == 200
				Rails.logger.info("Successfully create pickup and delivery task for order##{order.id} (#{response['data']})")
			else
				Rails.logger.error("Failed to create pickup and delivery task #{response}")
			end
		end

	end

end