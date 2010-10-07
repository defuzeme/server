# == Schema Information
#
# Table name: radios
#
#  band        :integer
#  created_at  :datetime
#  description :text
#  frequency   :float
#  id          :integer       not null, primary key
#  name        :string(255)
#  permalink   :string(255)
#  updated_at  :datetime
#  user_id     :integer
#  website     :string(255)
#

class Radio < ActiveRecord::Base
  extend Defuzeme::Enum

  validates :name,
    :presence   => true,
    :length     => { :within => 2..100 },
    :format     => { :with => Authentication.name_regex }

  validates :permalink,
    :presence   => true,
    :uniqueness => true,
    :length     => { :within => 2..40 },
    :format     => { :with => /^[a-z0-9\-_]+$/ }
  
  validates :description,
    :length     => { :within => 0..500, :allow_blank => true }
  
  validates :frequency,
    :numericality => { :greater_than => 87, :less_than => 109, :allow_nil => true }

  validates :website,
    :format     => { :with => /^http:\/\/[a-z0-9\-_\.]+\/?$/i, :allow_blank => true }

  enum :band, %w(fm am)
  
  has_many :users
end
