require 'encryptor'

class Encryptinator

  def self.encrypt_string(plain_text)
    secret_key = Digest::SHA256.hexdigest(ENV['ENCRYPTION_KEY'])
    encrypted_value = Encryptor.encrypt(plain_text, 
    	:key => secret_key, :algorithm => 'bf')
    encrypted_value
  end  

  def self.decrypt_string(encrypted_text)
    secret_key = Digest::SHA256.hexdigest(ENV['ENCRYPTION_KEY'])
    decrypted_value = Encryptor.decrypt(encrypted_text, 
    	:key => secret_key, :algorithm => 'bf')
    decrypted_value
  end  

end