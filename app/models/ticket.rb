class Ticket < ActiveRecord::Base
  belongs_to :ticket_status
  belongs_to :department
  belongs_to :user

  EMAIL_REGEX = /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :name, :subject, :question, presence: true
  
  before_create :email_downcase!

  delegate :name, to: :ticket_status, prefix: true, allow_nil: true
  delegate :name, to: :department, prefix: true, allow_nil: true

private
  def email_downcase!
    self.email.downcase!
  end
end
