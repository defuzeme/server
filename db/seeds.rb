# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

u = User.create!(:login => 'bigbourin', :email => 'bigbourin@gmail.com',
      :first_name => 'Adrien', :last_name => 'Jarthon', :password => 'jambon',
      :password_confirmation => 'jambon', :invitation_code => 'd#ve7aS4')
u.admin = true
u.activate!

