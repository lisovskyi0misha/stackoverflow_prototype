require 'rails_helper'

describe 'Profiles Controller' do
  describe 'GET# index' do
    let!(:users) { create_list(:user, 3) }

    context 'without search' do
      before { get '/profiles' }

      it 'finds users' do
        expect(assigns(:users)).to eq(users)
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end

      context 'with search' do
        let!(:user) { create(:user, email: 'ransack@email.com') }

        it 'finds all users' do
          get '/profiles'
          expect(assigns(:users)).to eq(users << user)
        end

        it 'searches specific users' do
          get '/profiles', params: { q: { email_cont: 'ransack' } }
          expect(assigns(:users)).to eq([user])
        end
      end
    end
  end
end
