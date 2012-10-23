require 'spec_helper'

describe Encryptinator do
	it "should encrypt and decrypt successfully" do
		plain_text_string = 'abcd898#$#%!@#$%^&*()_+44A'
		encrypted_string = Encryptinator.encrypt_string(plain_text_string)
		decrypted_string = Encryptinator.decrypt_string(encrypted_string)
		decrypted_string.should == plain_text_string
	end
end
