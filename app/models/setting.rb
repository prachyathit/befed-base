class Setting < ActiveRecord::Base

  enum value_type: [ :string, :integer, :float, :boolean ]

  validates :key, :value, :value_type, presence: true
  validate :valid_value, on: :update

  def self.get key
    setting = Setting.where(key: key).first
    if setting.present?
      setting.real_value  
    end
  end

  def self.set key, value, type=nil
    setting = Setting.find_or_initialize_by(key: key)
    setting.value = value.to_s
    setting.value_type = type if type
    setting.save
  end

  def real_value
    case value_type.to_sym
    when :integer
      value.to_i
    when :float
      value.to_f
    when :boolean
      value == "true"
    else
      value
    end
  end

  def valid_value
    case value_type.to_sym
    when :integer
      true if Integer(value) rescue record.errors[:value] << 'must be an Integer.'
    when :float
      true if Float(value) rescue record.errors[:value] << 'must be a Float.'
    when :boolean
      unless value == 'true' or value == 'false'
        record.errors[:value] << 'must be a Boolean.'
      end
    else
    end
  end
end
