RSpec.shared_examples 'edit' do
  before { do_edit_request }

  it "finds #{return_instance_name}" do
    expect(assigns(instance)).to eq(object)
  end

  it 'renders edit' do
    expect(response).to render_template :edit
  end
end
