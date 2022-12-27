RSpec.shared_examples 'valid create' do
  it "saves #{return_instance_name}" do
    expect { do_create_request(object) }.to change(object_for_count, :count).by(1)
  end

  it 'saves file to db' do
    do_create_request(object, files: true)
    expect(assigns(instance).files.first.blob.filename).to eq('test_file.txt')
  end
end

RSpec.shared_examples 'invalid create' do
  context 'with invalid attributes' do
    it "doesn`t create #{return_instance_name}" do
      expect { do_invalid_create_request }.to_not change(object_for_count, :count)
    end

    it "re-renders #{resource} page" do
      do_invalid_create_request
      expect(response).to render_template template
      expect(response).to have_http_status(422)
    end
  end
end
