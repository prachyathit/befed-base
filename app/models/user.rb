class User < ActiveRecord::Base
  attr_accessor :remember_token, :reset_token
  before_save :downcase_email
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: { minimum: 9 }, uniqueness: true
  # validates :address, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  default_scope -> { order(:id) }
  #Geolocation
  # Geocoder gives wrong Latlng!!!!!!!!!!!!!
  # after_validation :reverse_geocode
  # reverse_geocoded_by :latitude, :longitude, :address => :location
  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :geocode, :reverse_geocode

  has_many :payments
  has_many :orders
  has_many :addresses

  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def generate_access_token
    begin
      self.access_token = User.new_token
    end while User.exists?(access_token: access_token)
    self.save
    self.access_token
  end

  def remove_access_token
    self.update(access_token: nil)
  end

  # Remembers a user in the database for user in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def valid_password?(password)
    authenticated?(:password, password)
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Sets the password reset attribute
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if as password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def default_address
    self.addresses.where(is_default: true).first
  end

  def set_default_address(address)
    self.addresses.update_all(is_default: false)
    address.update(is_default: true)
  end

  private

  # Converts email to all lower case
  def downcase_email
    self.email = email.downcase
  end

  def self.to_csv
    attributes = %w{id name email phone address latitude longitude dinstruction created_at updated_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      
      all.each do |user|
        csv << user.attributes.values_at(*attributes)
      end
    end
  end

end
