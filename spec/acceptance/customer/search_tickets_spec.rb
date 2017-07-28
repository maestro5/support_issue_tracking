require_relative '../acceptance_helper.rb'

feature 'Customer (visitor) search tickets', %q{
  As a customer
  I able to search in completed tickets by word or combinations of words
} do

  given(:subjects) { ['first ticket subject', 'testing, rspec clean elastic search?', 'another subject'] }
  given(:questions) { ['another question', 'test ticket question', 'best practice for elastic search testing?'] }
  given!(:open_tickets) { create_custom_tickets subjects, questions }
  given!(:completed_tickets) { create_custom_tickets subjects, questions, TicketStatus.completed }

  before do
    Ticket.reindex
    visit root_path
  end

  scenario 'when search field is empty' do
    click_on 'Search'
    expect(page.status_code).to be(200)
  end

  context 'search in subjects and questions' do
    scenario 'when one word' do
      fill_in 'search', with: 'ticket'
      click_on 'Search'

      expect(current_path).to eq root_path
      expect(page).to have_content subjects[0], count: 1
      expect(page).to have_content subjects[1], count: 1
      expect(page).not_to have_content subjects[2], count: 1
    end
    scenario 'when two words' do
      fill_in 'search', with: 'testing elastic'
      click_on 'Search'

      expect(current_path).to eq root_path
      expect(page).not_to have_content subjects[0], count: 1
      expect(page).to have_content subjects[1], count: 1
      expect(page).to have_content subjects[2], count: 1
    end
  end

end
