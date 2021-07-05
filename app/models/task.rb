require 'active_support/time'
require 'active_support/core_ext/numeric/time.rb'

class Task < ApplicationRecord

  belongs_to :user
  after_save :create_mail

  validates :status, inclusion: { in: ['backlog', 'in-progress', 'done']}

  STATUS_OPTIONS = [
    ['Backlog', 'backlog' ],
    ['In Progress', 'in-progress'],
    ['Done', 'done']
  ]

  def badge_color
    case status
    when 'backlog'
      'secondary'
    when 'in-progress'
      'info'
    when 'done'
      'success'
    end
  end

  def create_mail 
    day_ago_from_deadline = (self.deadline - 1 * 24 * 60 * 60)
    hour_ago_from_deadline = (self.deadline - 24 * 60 * 60)
    UserMailer.reminder_email(self).deliver_later(wait_until: ((self.deadline - day_ago_from_deadline) / 1.hours).to_i.hour.from_now) unless day_ago_from_deadline < Time.now
    UserMailer.reminder_email(self).deliver_later(wait_until: ((self.deadline - hour_ago_from_deadline) / 1.hours).to_i.hour.from_now)   
  end

end
