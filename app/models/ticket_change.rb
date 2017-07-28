class TicketChange < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :changeable, polymorphic: true
end
