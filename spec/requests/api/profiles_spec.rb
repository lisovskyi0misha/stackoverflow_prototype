require 'rails_helper'

describe 'Profile API' do
  describe 'GET #me' do
    context 'unauthorized user' do
      it 'gets unauthorized error with no access token' do
        get '/api/v1/profiles/me'
        expect(response.status).to eq(401)
      end

      it 'gets unauthorized error with invalid access token' do
        get '/api/v1/profiles/me', params: { access_token: '132456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized user' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token } }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      %w[email id created_at updated_at admin].each do |attr|
        it "contains user`s #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "doesn`t contain user`s #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #all' do
    context 'unauthorized user' do
      it 'gets unauthorized error with no access token' do
        get '/api/v1/profiles/all'
        expect(response.status).to eq(401)
      end

      it 'gets unauthorized error with invalid access token' do
        get '/api/v1/profiles/all', params: { access_token: '132456' }
        expect(response.status).to eq(401)
      end
    end

    context 'authorized user' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 3) }

      before { get '/api/v1/profiles/all', params: { access_token: access_token.token, format: :json } }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns unauthorized users' do
        users.each do |user|
          expect(response.body).to be_json_eql(user.to_json).at_path("user_#{user.id}")
        end
      end

      it 'doesn`t return authorized user' do
        expect(response.body).to_not have_json_path("user_#{me.id}")
      end
    end
  end
end
