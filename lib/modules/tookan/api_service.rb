module Tookan
	require 'rest_client'

	class ApiService

		TOOKAN_API_URL = 'https://api.tookanapp.com:8888'

		def create_pickup_and_delivary_task user, cart, order
			restaurant = Restaurant.find(order.rest_id)

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
				timezone: "-420", #UTC+7
				# fleet_id: "636", assign task to specific agent id
				p_ref_images: [],
				ref_images: [],
				notify: 1,
				tags: [],
				geofence: 1,
				
				# pickup info
				job_description: "",
				job_pickup_phone: "",
				job_pickup_name: restaurant.name,
				job_pickup_email: "",
				job_pickup_address: restaurant.address,
				job_pickup_latitude: restaurant.latitude,
				job_pickup_longitude: restaurant.longitude,
				job_pickup_datetime: (DateTime.now + 15.minutes).to_s(:db), #YYYY-MM-DD HH:MM:SS
				
				pickup_custom_field_template: "Pickup",
				pickup_meta_data: [
				  {
				    label: "Order",
				    data: order.id
				  }
				],
				
				# delivery info				
				customer_email: user.email,
				customer_username: user.name,
				customer_phone: user.phone,
				customer_address: user.address,
				
				latitude: user.latitude,
				longitude: user.longitude,

				job_delivery_datetime: (DateTime.now + 45.minutes).to_s(:db), #YYYY-MM-DD HH:MM:SS
				custom_field_template: "Delivery",
				meta_data: [
				  {
				    label: "DeliveryInstruction",
				    data: user.dinstruction
				  },
				  {
				    label: "Phone",
				    data: user.phone
				  },
				  {
				  	label: "Price",
				  	data: order.total
				  }
				]
			}

			response = RestClient.post TOOKAN_API_URL+'/create_task', params, headers
		end

	end

end