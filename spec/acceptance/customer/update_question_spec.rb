require_relative '../acceptance_helper.rb'

feature 'Customer update the ticket', %q{
  As a customer
  I able to update the ticket (send a new question)
} do

  given(:user) { create :user }
  given!(:waiting_customer_status) { create :ticket_status }
  given!(:ticket) { create :ticket, user_id: user.id }
  given!(:manager_answer) { create :message, ticket_id: ticket.id, user_id: user.id }

  scenario 'when reference number not equal render the homepage with an error message' do
    visit edit_ticket_path(ticket, ref_number: 'ABC-2k-CQL-8h-OQM')
    expect(current_url).to eq root_url
    expect(page).to have_content 'The reference number for the ticket does not match!'
  end
  scenario 'render ticket edit page' do
    visit edit_ticket_path(ticket, ref_number: ticket.reference_number)
    expect(current_url).to eq edit_ticket_url(ticket, ref_number: ticket.reference_number)
  end
  scenario 'when adds an clarification question without message' do
    ticket.update_attribute(:ticket_status, waiting_customer_status)
    visit edit_ticket_path(ticket, ref_number: ticket.reference_number)
    expect { click_on 'Update Ticket' }
      .to not_change{ ticket.ticket_status }
      .and not_change(Message, :count)
    expect(page).to have_content "Message [:body, [\"can't be blank\"]]"
  end

  context 'when adds a valid clarification question' do
    let(:default_ticket_status) { create :ticket_status, name: 'waiting for staff response' }
    let(:customer_message) { 'Test valid clarification question'}
    before do
      visit edit_ticket_path(ticket, ref_number: ticket.reference_number)
      fill_in 'ticket[messages][body]', with: customer_message
    end
    scenario 'save message in database' do
      expect { click_on 'Update Ticket' }.to change(Message, :count).by(1)
    end
    scenario 'set default status' do
      ticket.update_attribute(:ticket_status, waiting_customer_status)
      click_on 'Update Ticket'
      expect(ticket.reload.ticket_status.name).to eq default_ticket_status.name
    end
    scenario 'redirect to ticket show page' do
      click_on 'Update Ticket'
      expect(current_path).to eq ticket_path ticket
      expect(page).to have_content 'Your ticket has been successfully updated!'

      # ticket
      expect(page).to have_content ticket.subject
      expect(page).to have_content ticket.question
      expect(page).to have_content ticket.department_name
      expect(page).to have_content ticket.name
      expect(page).to have_content ticket.created_at

      # messages
      expect(page).to have_content user.name
      expect(page).to have_content manager_answer.body
      expect(page).to have_content customer_message
    end
  end
end
