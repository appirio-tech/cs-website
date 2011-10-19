
# set production environment in heroku directly.
# rails s --environment=test 

unless Rails.env.production?
  # administrator sfdc sandbox username
  ENV['sfdc_username'] = 'jeff@cloudspokes.com.sandbox'
  # administrator sfdc sandbox password
  ENV['sfdc_password'] = '8fuJk2uwZQ'
  # the password used for all third party users when logging in. 
  # Make sure it matches the 'Platform Settings' custom setting 'Third Party Password' in sfdc
  ENV['third_party_password'] =  '!cloudspokes963'
  # this is appended to the member's username when creating new users plus when logging in. 
  # Make sure it matches the 'Platform Settings' custom setting 'Email Domain' in sfdc
  ENV['sfdc_username_domain'] = 'sandbox.cloudspokes.com'
  # the CloudSpokes URI and API verson
  ENV['sfdc_instance_url'] = 'https://cs10.salesforce.com/services/apexrest/v.9'
end