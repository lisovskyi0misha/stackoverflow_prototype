RSpec.shared_examples 'vote' do
  def return_instance_name
    instance
  end

  it "finds #{return_instance_name}" do
    return_instance_name
    do_request(authors_object)
    expect(assigns(instance)).to eq(authors_object)
  end

  context "user tries to like other`s #{return_instance_name} once" do
    it 'saves vote to db' do
      expect { do_request(authors_object) }.to change(authors_object, :rate).by(1)
    end

    it 'renders vote' do
      do_request(authors_object)
      expect(response).to render_template :vote
    end
  end

  context "user tries to dislike other`s #{return_instance_name} once" do
    it 'saves vote to db' do
      expect { do_request(authors_object, 'disliked') }.to change(authors_object, :rate).by(-1)
    end
  end

  context "user tries to vote other`s #{return_instance_name} twice" do
    it 'saves only one vote to a db' do
      expect { do_request(authors_object) }.to change(authors_object, :rate).by(1)
      expect { do_request(authors_object) }.to_not change(authors_object, :rate)
    end
  end

  context "user tries to vote for his own #{return_instance_name}" do
    it 'dosen`t vote like to db' do
      expect { do_request(others_object) }.to_not change(others_object, :rate)
    end
  end
end
