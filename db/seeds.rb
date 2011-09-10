# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

puts "Creating admin accounts"

User.destroy_all
def create_admin login, email, first_name, last_name
  u = User.new(:login => login, :email => email,
        :first_name => first_name, :last_name => last_name, :password => 'd#ve7aS4',
        :password_confirmation => 'd#ve7aS4')
  u.admin = true
  u.invitations_left = 20
  u.save
  u.activate!
end

create_admin 'bigbourin', 'bigbourin@gmail.com',      'Adrien',   'Jarthon'
create_admin 'dreewoo',   'dreewoo@gmail.com',        'Jocelyn',  'De La Rosa'
create_admin 'arnoo',     'arnoo.sel@gmail.com',      'Arnaud',   'Sellier'
create_admin 'athena',    'athylynna@gmail.com',      'Athena',   'Calmettes'
create_admin 'luc',       'luc.peres.88@gmail.com',   'Luc',      'Peres'
create_admin 'GaYa',      'gailla.fr@gmail.com',      'Francois', 'Gaillard'
create_admin 'greys',     'moore.alexandre@gmail.com','Alexandre','Moore'

puts "Creating demo radio"

Radio.destroy_all
radio = Radio.create(:name => 'Defuze.me demo radio', :website => 'defuze.me', :description => 'This radio is not phisically existing and is only used by defuze.me development team')
radio.users = User.all

puts "Creating audio tracks"

Track.destroy_all
Track.create(:name => 'Last Friday Night', :artist => 'Katy Perry', :album => 'Teenage Dream', :year => 2010, :genre => 'pop', :duration => 230);
Track.create(:name => 'Talkin Bout A Revolution', :artist => 'Tracy Chapman', :album => 'The Collection', :year => 2001, :genre => 'rock', :duration => 160);
Track.create(:name => 'Charlies Groove', :artist => 'New Jersey Kings', :album => 'Party to the Bus Stop', :year => 1996, :genre => 'Funk', :duration => 323);
Track.create(:name => 'Beast', :artist => 'Galactic', :album => 'Ruckus', :year => 2003, :genre => 'rock', :duration => 169);
Track.create(:name => 'Pastime Paradise', :artist => 'Youngblood Brass Band', :album => 'Unlearn', :year => 2001, :genre => 'Jazz-Hop', :duration => 370);
Track.create(:name => 'Map of the Problematique', :artist => 'Muse', :album => 'Black Holes and Revelations', :year => 2006, :genre => 'Rock', :duration => 258);
Track.create(:name => 'Dezzerd', :artist => 'Daft Punk', :album => 'Tron Legacy OST', :year => 2010, :genre => 'Soundtrack', :duration => 104);
Track.create(:name => 'The Good Life', :artist => 'Bobby Darin', :album => 'Matchstick Men', :year => 2003, :genre => 'Soundtrack', :duration => 143);
Track.create(:name => 'Le Freak', :artist => 'Chic', :genre => 'Disco', :duration => 280);
Track.create(:name => 'Teenage Dream', :artist => 'Katy Perry', :album => 'Teenage Dream', :year => 2010, :genre => 'pop', :duration => 228);
Track.create(:name => 'California Gurls', :artist => 'Katy Perry', :album => 'Teenage Dream', :year => 2010, :genre => 'pop', :duration => 236);

puts "Filling play queue"

radio.queue_elems.create(:position => 0, :track_id => 1);
radio.queue_elems.create(:position => 1, :track_id => 3);
radio.queue_elems.create(:position => 2, :track_id => 2);
radio.queue_elems.create(:position => 3, :track_id => 6);
radio.queue_elems.create(:position => 4, :track_id => 5);
radio.queue_elems.create(:position => 5, :track_id => 4);
radio.queue_elems.create(:position => 6, :track_id => 8);
radio.queue_elems.create(:position => 7, :track_id => 7);
radio.queue_elems.create(:position => 8, :track_id => 9);

puts "Clear invitations"

Invitation.destroy_all
