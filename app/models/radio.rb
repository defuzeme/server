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
#  website     :string(255)
#

class Radio < ActiveRecord::Base
  extend Defuzeme::Enum

  validates :name,
    :presence   => true,
    :length     => { :within => 2..100 }

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
    :format     => { :with => /^(http:\/\/)?[a-z0-9\-_\.]+\/?$/i, :allow_blank => true }

  enum :band, %w(fm am)
  
  has_many :users, :dependent => :nullify
  has_many :invitations, :dependent => :nullify
  has_many :queue_elems, :dependent => :destroy
  
  before_validation :generate_permalink
  after_validation :report_permalink_uniqueness
  
  def editable_by? user
    user and (user_ids.include? user.id or user.admin?)
  end
  
  def to_param
    permalink
  end
  
  def frequency_band
    "#{frequency} MHz #{band_key.to_s.upcase}"
  end
  
  protected
  
  # Because there's no permalink field, we need to show errors on name field
  def report_permalink_uniqueness
    errors[:name] << errors[:permalink] if errors[:permalink]
  end
  
  def generate_permalink
    self.permalink ||= name.parameterize
  end
end
