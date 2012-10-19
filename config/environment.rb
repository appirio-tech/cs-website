# Load the rails application
require File.expand_path('../application', __FILE__)
# load fastpass for getsatisfaction
require 'fastpass'
require 'encryptinator'

# Initialize the rails application
CloudSpokes::Application.initialize!

