class User
  include RedisRecord
  include ActiveModel::SecurePassword
  include ActiveModel::Validations
  include ActiveModel::AttributeAssignment
  include ActiveModel::Serialization
  #since not using activerecord orm due to the redis datastore, need to include module to access has_secure_password
  has_secure_password
  attr_accessor :username, :password_hash, :password_digest

  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,}) #At least 8 characters long
    (?=.*\d) # Contain at least one number
    (?=.*[a-z]) # Contain at least one lowercase letter
    (?=.*[A-Z]) # Contain at least one uppercase letter
    (?=.*[[:^alnum:]]) # Contain at least one symbol
    /x

  validates :username, presence: true
  validates :password, presence: true, format: PASSWORD_REQUIREMENTS

  def initialize(attributes = {})
    self.assign_attributes(attributes)
  end

  def attributes
    {'username' => nil, 'password_digest' => nil, 'password'=> nil}
  end


  def unique_username(username)
     if $redis_credentials.get(username).nil?
       return true
     else
       return false
     end
  end
end
