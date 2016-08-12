class MenuSerializer < ActiveModel::Serializer
	attributes :id, :name, :price, :image_url, :appear
	attribute :rec, key: :recommend
	attribute :cat, key: :category
end
