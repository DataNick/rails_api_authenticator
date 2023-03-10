class User
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

  def save_to_redis_store
    if self.valid? && unique_username(self.username)
      $redis_credentials.set(self.username, self.password_digest)
      return self
    else
      return false
    end
  end

  def find_by_username(username)
    password_digest = $redis_credentials.get(username)
    if password_digest.nil?
      return nil
    else
      self.new(username:username, password_digest:password_digest)
    end
  end

  def unique_username(username)
     if $redis_credentials.get(username).nil?
       return true
     else
       return false
     end
  end
end
