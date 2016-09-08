class Address < ActiveRecord::Base

	belongs_to :user

	validates_presence_of :user, :latitude, :longitude
	validates :name, uniqueness: true, if: "self.name.present?"
	validates_uniqueness_of :is_default, :scope => :user_id, :unless => Proc.new { |address| not address.is_default }

	before_create :mark_address_as_default, unless: "user.addresses.present?"
	before_destroy :prevent_default_address_from_deletion

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

end
