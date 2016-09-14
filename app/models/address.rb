class Address < ActiveRecord::Base

	belongs_to :user

	validates_presence_of :user, :latitude, :longitude
	validates :name, uniqueness: true, if: "self.name.present?"
	validates_uniqueness_of :is_default, :scope => :user_id, :unless => Proc.new { |address| not address.is_default }

	before_create :mark_address_as_default, unless: "user.addresses.present?"

	def mark_address_as_default
		self.is_default = true
	end

  def full_address
    full_street = street+" Rd." if street.present?
    full_floor = "floor "+floor if floor.present?
    [house_room_no, building_name, full_floor, full_street, province, postal_code].join(" ")
  end

end
