class Ticket < ActiveRecord::Base
  belongs_to :ticket_status
  belongs_to :department
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :ticket_changes, dependent: :destroy

  EMAIL_REGEX = /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :name, :subject, :question, presence: true
  
  before_create :email_downcase!

  delegate :name, to: :ticket_status, prefix: true, allow_nil: true
  delegate :name, to: :department, prefix: true, allow_nil: true

  scope :unassigned, -> { where(user_id: nil).order(created_at: :asc) }
  scope :closed, -> { where(ticket_status: TicketStatus.completed).order(created_at: :asc) }
  scope :customer_search, -> (words) { Ticket.search(words, fields: [:subject, :question]).records.closed if words }

  searchkick

private
  def email_downcase!
    self.email.downcase!
  end
end
