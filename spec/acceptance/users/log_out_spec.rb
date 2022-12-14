require 'rails_helper'

feature 'User log out' do
  scenario 'Authenticated users trying to log out' do
    User.create(email: 'user@test.com', password: '12345678')
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    visit root_path
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq new_user_session_path
  end
end