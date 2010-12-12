# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

puts "Creating admin accounts"

def create_admin login, email, first_name, last_name
  u = User.create!(:login => login, :email => email,
        :first_name => first_name, :last_name => last_name, :password => 'd#ve7aS4',
        :password_confirmation => 'd#ve7aS4', :invitation_code => 'd#ve7aS4')
  u.admin = true
  u.activate!
end

create_admin 'bigbourin', 'bigbourin@gmail.com',      'Adrien',   'Jarthon'
create_admin 'dreewoo',   'dreewoo@gmail.com',        'Jocelyn',  'De La Rosa'
create_admin 'arnoo',     'arnoo.sel@gmail.com',      'Arnaud',   'Sellier'
create_admin 'athena',    'athylynna@gmail.com',      'Athena',   'Calmettes'
create_admin 'luc',       'luc.peres.88@gmail.com',   'Luc',      'Peres'
create_admin 'GaYa',      'gailla.fr@gmail.com',      'Francois', 'Gaillard'
create_admin 'greys',     'moore.alexandre@gmail.com','Alexandre','Moore'
