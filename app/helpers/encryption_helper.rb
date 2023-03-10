module Encryptor
  def encrypt(value)
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY'])
    encrypted_data = crypt.encrypt_and_sign(value)
  end

  def decrypt(encrypted_data)
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY'])
    crypt.decrypt_and_verify(encrypted_data)
  end
end
