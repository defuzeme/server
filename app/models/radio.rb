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
#  status      :integer
#  updated_at  :datetime
#  website     :string(255)
#

require 'eventmachine'
require 'em-http-request'

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
  enum :status, %w(stop play pause)
  
  has_many :users, :dependent => :nullify
  has_many :invitations, :dependent => :nullify
  has_many :queue_elems, :dependent => :destroy
  
  accepts_nested_attributes_for :queue_elems
  
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
  
  # Clean queue on global update
  def queue_elems_attributes= arg
    queue_elems.destroy_all
    assign_nested_attributes_for_collection_association(:queue_elems, arg)
    push_queue!
  end
  
  def reorder_queue elems
    pos_hash = queue_elems.find(elems).inject({}) {|h, e| h[e.id] = e.position; h}
    # Map each positions with it's offset from original position
    diff = elems.each_with_index.map do |p, i|
      (i + 1) - pos_hash[p]
    end
    # Find who moved
    moved = 0
    diff.each_with_index do |d, i|
      moved = i if d.abs > diff[moved].abs
    end
    if elem = queue_elems.find(elems[moved])
      old = elem.position
      elem.insert_at moved + 1
      push_to_client! :move => {:position => old, :newPosition => elem.position, :type => elem.kind, :track => elem.track}
    end
  end
  
  def push_queue!
    push_queue_to_web!
  end
  
  def push_queue_to_web!
    return if not EventMachine::reactor_running?
    http = EventMachine::HttpRequest.new("ws://localhost:8080/push/#{id}/web").get :timeout => 0
    http.errback do
      puts "WebSocket error: #{http.error}"
    end
    http.callback do
      queue = queue_elems.order(:position).includes(:track)
      http.send queue.map {|e| e.to_html}.join()
      http.close_connection_after_writing
    end
    http.stream do |msg|
    end
  end

  def push_to_client! data
    return if not EventMachine::reactor_running?
    http = EventMachine::HttpRequest.new("ws://localhost:8080/push/#{id}/client").get :timeout => 0
    http.errback do
      puts "WebSocket error: #{http.error}"
    end
    http.callback do
      http.send data.to_json
      http.close_connection_after_writing
    end
    http.stream do |msg|
    end
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
