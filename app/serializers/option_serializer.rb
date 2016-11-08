class OptionSerializer < ActiveModel::Serializer
	attributes :id, :name, :position, :min, :max, :option_type
	
	has_many :option_values
end
