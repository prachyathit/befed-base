class OptionSerializer < ActiveModel::Serializer
	attributes :id, :name, :position, :min, :max
	
	has_many :option_values
end
