class MenuSerializer < ActiveModel::Serializer
	attributes :id, :name, :price, :image_url, :appear, 
    :thai_name, :eng_name, :have_option
	attribute :rec, key: :recommend
	attribute :cat, key: :category
end
