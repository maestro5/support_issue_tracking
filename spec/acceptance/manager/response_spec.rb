require_relative '../acceptance_helper.rb'

feature 'Manager creates a response', %q{
  As a manager
  I able to create a response to a ticket
} do

  given(:user) { create :user, manager: true }
  given!(:department) { create :department }
  given!(:unasigned_ticket_one) { create :ticket, subject: 'Unasigned ticket', department: department }
  given!(:unasigned_ticket_two) { create :ticket }
  given!(:signed_ticket) { create :ticket, subject: 'Signed ticket', user_id: user.id }

  before { sign_in user}

  scenario 'when shows a list of all unassigned, open tickets' do
    expect(current_path).to eq '/'
    expect(page).to have_link unasigned_ticket_one.subject
    expect(page).to have_link unasigned_ticket_two.subject
    expect(page).not_to have_link signed_ticket.subject
  end

  scenario 'render edit view' do
    click_on unasigned_ticket_one.subject

    expect(current_path).to eq edit_ticket_path(unasigned_ticket_one)
    expect(page).to have_content unasigned_ticket_one.subject
    expect(page).to have_content unasigned_ticket_one.question
    expect(page).to have_content unasigned_ticket_one.name
    expect(page).to have_content unasigned_ticket_one.department.name
    expect(page).to have_content unasigned_ticket_one.created_at
    expect(page).to have_content unasigned_ticket_one.ticket_status_name
  end

  context 'when update ticket without changes' do
    before { click_on unasigned_ticket_one.subject }
    scenario 'not tracked without owner or status changes' do
      expect {click_on 'Update Ticket'}.not_to change(TicketStatus, :count)
    end
    context 'when answer is empty' do
      scenario 'not save in database' do
        expect { click_on 'Update Ticket' }.not_to change(Message, :count)
      end
      scenario 'not send notification letter to customer' do
        expect { click_on 'Update Ticket' }
          .not_to change { ActionMailer::Base.deliveries.count }
      end
    end # when answer is empty
    scenario 'redirect to edit ticket page' do
      expect(current_path).to eq edit_ticket_path(unasigned_ticket_one)
    end
  end

  # owner
  context 'when change the owner' do
    before do
      click_on unasigned_ticket_one.subject
      select user.email, from: 'ticket[user_id]'
      click_on 'Update Ticket'
    end
    scenario 'save in database' do
      expect(unasigned_ticket_one.reload.user).to eq user
    end
    scenario 'tracked' do
      expect(unasigned_ticket_one.ticket_changes.last.changeable).to eq user
    end
  end # when change the owner

  # status
  context 'when change the status' do
    let!(:ticket_status) { create :ticket_status }
    before do
      click_on unasigned_ticket_one.subject
      select ticket_status.name, from: 'ticket[ticket_status_id]'
      click_on 'Update Ticket'
    end
    scenario 'save in database' do
      expect(unasigned_ticket_one.reload.ticket_status).to eq ticket_status
    end
    scenario 'tracked' do
      expect(unasigned_ticket_one.ticket_changes.last.changeable).to eq ticket_status
    end
  end

  # answer
  context 'when fill an answer' do
    let(:manager_answer) { 'Test manager answer' }
    before do
      click_on unasigned_ticket_one.subject
      fill_in 'ticket[messages][body]', with: manager_answer
    end
    scenario 'save in database' do
      expect { click_on 'Update Ticket' }.to change(Message, :count).by(1)
      expect(unasigned_ticket_one.messages.last.body).to eq manager_answer
    end
    scenario 'send notification letter to customer' do
      expect { click_on 'Update Ticket' }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

end
