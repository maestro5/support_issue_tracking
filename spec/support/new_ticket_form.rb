class NewTicketForm
  include Capybara::DSL

  def visit_page
    visit '/'
    click_on 'Add ticket'
    self
  end

  def fill_in_with(params = {})
    fill_in 'ticket[name]',  with: params.fetch(:name, '')
    fill_in 'ticket[email]',  with: params.fetch(:email, '')
    fill_in 'ticket[subject]',  with: params.fetch(:subject, '')
    fill_in 'ticket[question]', with: params.fetch(:question, '')
    select params.fetch(:department, ''), from: 'ticket[department_id]'

    self
  end

  def submit
    click_on 'Create Ticket'
    self
  end
end
