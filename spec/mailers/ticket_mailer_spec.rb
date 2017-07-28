require "rails_helper"

RSpec.describe TicketMailer, type: :mailer do
  let(:ticket) { create :ticket }
  let(:message) { 'Test email message' }
  let(:mail) { TicketMailer.ticket_notification(ticket, message).deliver_now }
  
  it 'renders the sender email' do
    expect(mail.from).to eq(['from@example.com'])
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq [ticket.email]
  end

  it 'renders the subject' do
    expect(mail.subject).to eq 'Ticket confirmation'
  end

  it 'assigns @message' do
    expect(mail.body.encoded).to match(message)
  end

  it 'assigns @reference_number' do
    expect(mail.body.encoded).to match(ticket.reference_number)
  end

  it 'assigns @ticket_url' do
    expect(mail.body.encoded).to match ticket_url(ticket)
  end
end
