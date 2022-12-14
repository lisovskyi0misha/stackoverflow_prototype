require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  describe 'for quest' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for authenticated user' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user_id: author.id) }
    let(:answer) { create(:answer, question_id: question.id, user_id: author.id) }
    let(:subscription) { question.subscriptions.create(user_id: user.id) }

    context 'for all objects' do
      subject(:ability) { Ability.new(user) }

      it { should be_able_to :create, Subscription }
    end

    context 'user`s own objects' do
      subject(:ability) { Ability.new(author) }

      it { should_not be_able_to :manage, :all }
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :new_for_answer, Comment }
      it { should be_able_to :new_for_question, Comment }
      it { should be_able_to :create, Comment }

      %i[destroy update].each do |action|
        it { should be_able_to action, question, user: author }
        it { should be_able_to action, answer, user: author }
      end

      it { should be_able_to :choose_best, answer, question: { user: author } }
      it { should be_able_to :delete_best, answer, question: { user: author } }
      it { should_not be_able_to :vote, question, user: author }
      it { should_not be_able_to :vote, answer, user: author }
    end

    context 'other`s objects' do
      subject(:ability) { Ability.new(user) }

      %i[destroy edit update].each do |action|
        it { should_not be_able_to action, question, { user: } }
        it { should_not be_able_to action, answer, { user: } }
      end

      it { should_not be_able_to :delete_best, answer, question: { user: author } }
      it { should_not be_able_to :choose_best, answer, question: { user: author } }
      it { should be_able_to :vote, question, { user: } }
      it { should be_able_to :vote, answer, { user: } }
    end
  end
end
