class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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

end
