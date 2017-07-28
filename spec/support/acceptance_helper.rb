module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    click_on 'Sign In'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'password'
    click_on 'Log in'
  end

  def create_custom_tickets(subjects, questions, status = nil)
    subjects
      .zip(questions)
      .inject([]) do |res, el|
        ticket = create(:ticket, subject: el[0], question: el[1])
        ticket.update_attribute(:ticket_status, status) if status
        res << ticket
      end
  end
end # AcceptanceHelper