# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Term.create!(:name => 'Standard Terms & Conditions', :description => 'Standard Terms and Conditions. See http://www.cloudspokes.com/tos.')
Term.create!(:name => 'Terms and Conditions 2.0', :description => 'The version 2 of our terms. More text to come.')
Term.create!(:name => 'Box.net', :description => 'Box.net specific terms for their challenges.')
Term.create!(:name => 'SFDC Hackathon', :description => 'The terms for the 2011 SFDC Hackathon.')


