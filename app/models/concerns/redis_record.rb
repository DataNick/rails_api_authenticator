module RedisRecord
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def find_by_username(username)
      if $redis_credentials.get(username)
        return true
      else
        return false
      end
    end
  end

  def save_to_redis_store
    if self.valid? && unique_username(self.username)
      $redis_credentials.set(self.username, self.password_digest)
      return self
    else
      return false
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
