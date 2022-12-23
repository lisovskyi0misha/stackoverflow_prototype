module RequestMacros
  def unauthorized_user_context(url = '')
    context 'unauthorized user' do
      it 'gets unauthorized error with no access token' do
        get "/api/v1/questions/#{url}"
        expect(response.status).to eq(401)
      end

      it 'gets unauthorized error with invalid access token' do
        get "/api/v1/questions/#{url}", params: { access_token: '132456' }
        expect(response.status).to eq(401)
      end
    end
  end
end
