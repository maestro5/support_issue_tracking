require_relative '../acceptance_helper.rb'
require_relative '../../support/new_ticket_form'

feature 'Customer (visitor) creates a ticket', %q{
  As a customer
  I able to create a ticket without login
} do

  given(:ticket_attrs) { attributes_for(:ticket) }
  given(:new_ticket_form) { NewTicketForm.new }

  context 'when customer creates invalid ticket' do
    scenario 'return error message when email is blank' do
      new_ticket_form.visit_page.fill_in_with(
        subject: ticket_attrs[:subject],
        question: ticket_attrs[:question]
      )

      expect { new_ticket_form.submit }.to change(Ticket, :count).by(0)
      expect(page).to have_content "Ticket [:email, [\"can't be blank\", \"is invalid\"]]"
    end

    scenario 'return error message when email is invalid' do
      new_ticket_form.visit_page.fill_in_with(
        email:   'wrongmailaddress.com',
        subject:  ticket_attrs[:subject],
        question: ticket_attrs[:question]
      )

      expect { new_ticket_form.submit }.to change(Ticket, :count).by(0)
      expect(page).to have_content "Ticket [:email, [\"is invalid\"]]"
    end

    scenario 'without subject' do
      new_ticket_form.visit_page.fill_in_with(
        email:    ticket_attrs[:email],
        question: ticket_attrs[:question]
      )

      expect { new_ticket_form.submit }.to change(Ticket, :count).by(0)
      expect(page).to have_content "Ticket [:subject, [\"can't be blank\"]]"
    end

    scenario 'without question' do
      new_ticket_form.visit_page.fill_in_with(
        email:   ticket_attrs[:email],
        subject: ticket_attrs[:subject]
      )

      expect { new_ticket_form.submit }.to change(Ticket, :count).by(0)
      expect(page).to have_content "Ticket [:question, [\"can't be blank\"]]"
    end
  end # invalid ticket

  context 'when customer creates valid ticket' do
    given!(:department) { create :department }
    before do
      new_ticket_form.visit_page.fill_in_with(
        name:       ticket_attrs[:name],
        email:      ticket_attrs[:email],
        department: department.name,
        subject:    ticket_attrs[:subject],
        question:   ticket_attrs[:question]
      )      
    end

    scenario 'save in database' do
      expect { new_ticket_form.submit }.to change(Ticket, :count).by(1)
      ticket = Ticket.last
      expect(ticket.name).to eq ticket_attrs[:name]
      expect(ticket.email).to eq ticket_attrs[:email]
      expect(ticket.subject).to eq ticket_attrs[:subject]
      expect(ticket.question).to eq ticket_attrs[:question]
      expect(ticket.department).to eq department
    end

    scenario 'generate unique ticket reference number' do
      new_ticket_form.submit
      expect(Ticket.last.reference_number).not_to be_nil
    end

    scenario 'set default ticket status' do
      new_ticket_form.submit
      expect(Ticket.last.ticket_status).to eq TicketStatus.default
    end

    scenario 'send a confirmation letter to the customer' do
      expect { new_ticket_form.submit }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    scenario 'redirect to ticket show page with success message' do
      new_ticket_form.submit
      expect(current_path).to eq ticket_path(Ticket.last)
      expect(page).to have_content 'Your ticket has been successfully created!'
    end
  end # valid ticket

end # Customer (visitor) creates a ticket
