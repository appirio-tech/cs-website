Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  
  # Change these keys and secrets during final deployment
  
  ##############################################################
  # LOCALHOST SANDBOX SETTINGS - http://localhost:3000
  ##############################################################
=begin   
  # CloudSpokes - localhost (127.0.0.1) - (jeffdonthemic)
  provider :twitter, 'KPJwFLfYmwj2Ug25aJgA', 'xa7HFNAIdGMfn6u20ph21yBdtpQHQ4Qykdq5rDV0'
  # CloudSpokes - localhost (127.0.0.1) (jeffdonthemic)
  provider :github, '791a5c9d36f560ee9353', '861d9a246f0273825c71dab4bb5d3dbdd79a0a9d'
  provider :facebook, '276941362338363', 'ecbbb475eaccb960f33835dd99310f75'
  provider :linked_in, 'x9onv3r7p08t', 'ma48Y34XpoqHl0XN'
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  # CloudSpokes - localhost OmniAuth (sandbox) 
  provider :salesforce, '3MVG9_7ddP9KqTzdCEqrJi8EiCaHybB6dDmVtKPlyfwexc6gKTEW3SyihW9xUjBdYpGRNc.Jb8GDugW7KopmT', '9125293366721641122'
=end
  ##############################################################
  # SANDBOX SETTINGS - cs-website-sandbox.herokuapp.com
  ##############################################################

  # cs-website-sandbox.herokuapp.com (jeffdonthemic)
  provider :twitter, 'amNlCNmGAi4cpVBs7ibbw', 'HK58KNnBtOTKNhU980dQgHHdKDW4qcfpdOXDDjsLZ8'
  # cs-website-sandbox.herokuapp.com (jeffdonthemic)
  provider :github, '74aa8b87118bbadb0998', 'a4046827f41ca1beee63dc28bbc4220a8580460e'  
  provider :facebook, '276941362338363', 'ecbbb475eaccb960f33835dd99310f75'
  provider :linked_in, 'x9onv3r7p08t', 'ma48Y34XpoqHl0XN'
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :salesforce, '3MVG9_7ddP9KqTzdCEqrJi8EiCaHybB6dDmVtKPlyfwexc6gKTEW3SyihW9xUjBdYpGRNc.Jb8GDugW7KopmT', '9125293366721641122'

  ##############################################################
  # PRODUCTION SETTINGS
  ##############################################################
=begin
  provider :twitter, 'KPJwFLfYmwj2Ug25aJgA', 'xa7HFNAIdGMfn6u20ph21yBdtpQHQ4Qykdq5rDV0'
  provider :facebook, '276941362338363', 'ecbbb475eaccb960f33835dd99310f75'
  provider :linked_in, 'x9onv3r7p08t', 'ma48Y34XpoqHl0XN'
  provider :github, '791a5c9d36f560ee9353', '861d9a246f0273825c71dab4bb5d3dbdd79a0a9d'
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :salesforce, '3MVG9_7ddP9KqTzdCEqrJi8EiCaHybB6dDmVtKPlyfwexc6gKTEW3SyihW9xUjBdYpGRNc.Jb8GDugW7KopmT', '9125293366721641122'
=end
end

# Change to wherever the app is hosted, required only for Salesforce, since it does not accept a http:// callback.
OmniAuth.config.full_host = 'http://cs-website-sandbox.herokuapp.com' 
