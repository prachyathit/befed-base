class Address < ActiveRecord::Base

	belongs_to :user

	validates_presence_of :user, :latitude, :longitude, :name
	validates_uniqueness_of :is_default, :scope => :user_id, :unless => Proc.new { |address| not address.is_default }

	before_create :mark_address_as_default, unless: "user.addresses.present?"
	before_destroy :prevent_default_address_from_deletion

	def self.default_from_params user, name, params
		address_params = JSON.parse(params["raw"])
		address_params[:user_id] = user.id
		address_params[:latitude] = params['latitude']
		address_params[:longitude] = params['longitude']
		address_params[:name] = name
		address = self.create(address_params)
		user.set_default_address(address)
		address
	end

	def mark_address_as_default
		self.is_default = true
	end

	def prevent_default_address_from_deletion
		if is_default or is_last_address?
			errors.add :base, "Cannot delete default address"
			return false
		end
	end

	def is_last_address?
		user.addresses.count == 1
	end

	def full_address
		street = "#{self.street} Rd." if self.street.present?
		building_name = "Building #{self.building_name}" if self.building_name.present?
		floor = "flr.#{self.floor}" if self.floor.present?
		[
			self.house_room_no, street, building_name, 
			floor, self.subdistrict, self.district, 
			self.province, self.postal_code
		].compact.join(' ')
	end

	def full_address_with_name
		self.name + " " + self.full_address
	end
end
