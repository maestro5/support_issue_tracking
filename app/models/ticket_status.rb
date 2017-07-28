class TicketStatus < ActiveRecord::Base
  class << self
    def default
      TicketStatus.find_or_create_by(name: 'waiting for staff response')
    end
    def completed
      TicketStatus.find_or_create_by(name: 'completed')
    end
    def on_hold
      TicketStatus.find_or_create_by(name: 'on_hold')
    end
  end
end
