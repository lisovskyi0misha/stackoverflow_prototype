require 'rails_helper'

feature 'User sign in', %q{
  To be able to create questions and answers
  As user
  I have to be authorized
} do

  given(:user) { create(:user) }
  scenario 'Registrated users trying to sign in' do
    
    authorize(user)
    
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registrated users trying to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end