require_relative '../acceptance_helper.rb'

feature 'User (manager) search tickets', %q{
  As a manager
  I able to search in open tickets by reference number,
  word or combinations of words
} do

  given(:user) { create :user }
  given(:subjects) { ['first ticket subject', 'testing, rspec clean elastic search?', 'another subject'] }
  given(:questions) { ['another question', 'test ticket question', 'best practice for elastic search testing?'] }
  given!(:completed_tickets) { create_custom_tickets subjects, questions, TicketStatus.completed }
  given!(:open_tickets) { create_custom_tickets subjects, questions }

  before do
    Ticket.reindex
    sign_in user
  end

  scenario 'when search field is empty' do
    click_on 'Search'
    expect(page.status_code).to be(200)
  end

  scenario 'search in subjects when two words' do
    fill_in 'search', with: 'testing elastic'
    click_on 'Search'

    expect(current_path).to eq root_path
    expect(page).not_to have_content subjects[0], count: 1
    expect(page).to have_content subjects[1], count: 1
    expect(page).not_to have_content subjects[2], count: 1
  end
  
  scenario 'when search in reference number' do
    open_ticket = open_tickets.sample
    fill_in 'search', with: open_ticket.reference_number
    click_on 'Search'

    expect(current_path).to eq root_path
    expect(page).to have_content open_ticket.subject, count: 1
  end

end
