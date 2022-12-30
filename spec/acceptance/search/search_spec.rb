require_relative '../acceptacne_helper'

feature 'search' do
  let!(:user) { create(:user, email: 'ransack@email') }
  scenario 'user`s search' do
    visit search_path
    fill_in 'Search', with: 'ransack'
    click_on 'Search'
    expect(page).to have_content(user.email)
  end
end
