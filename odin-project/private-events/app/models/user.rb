class User < ActiveRecord::Base
  has_many :created_events, :foreign_key => "creator_id", :class_name => "Event"
  has_many :invites,        :foreign_key => "attendee_id"
  has_many :attended_events, through: :invites

  validates :name,  presence: true
  validates :email, presence: true

  def attend(event)
    self.invites.create(:attended_event_id => event.id) if !event.attendees.include?(self)
  end

  def upcoming_events
    self.created_events.select { |event| check_date(event.date.to_date) }
  end

  def previous_events
    self.created_events.select { |event| !check_date(event.date.to_date)  }
  end

  def check_date(event_date)
    event_date > Date.today
  end
end
