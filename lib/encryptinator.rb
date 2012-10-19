require 'encryptor'
require 'base64'

class Encryptinator

  def self.encrypt_string(plain_text)
    secret_key = Digest::SHA256.hexdigest(ENV['ENCRYPTION_KEY'])
    encrypted_value = Encryptor.encrypt(:value => plain_text, 
    	:key => secret_key, :algorithm => 'bf')
    Base64.encode64(encrypted_value)
  end  

  def self.decrypt_string(encrypted_text)
    secret_key = Digest::SHA256.hexdigest(ENV['ENCRYPTION_KEY'])
    decrypted_value = Encryptor.decrypt(
    	:value => Base64.decode64(encrypted_text), 
    	:key => secret_key, :algorithm => 'bf')
    decrypted_value
  end  

end