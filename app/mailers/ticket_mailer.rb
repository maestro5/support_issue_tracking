class TicketMailer < ApplicationMailer
  def ticket_notification(ticket, message)
    @reference_number = ticket.reference_number
    @ticket_url = ticket_url ticket, ref_number: @reference_number
    @message = message
    mail(to: ticket.email, subject: 'Ticket confirmation')
  end
end
