require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  let(:author) { create(:user) }
  let(:authors_question) { create(:question, user_id: author.id) }
  let(:authors_answer) { create(:answer, question_id: authors_question.id, user_id: author.id) }

  sign_in_user

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates answer' do
        expect { answers_create_request(question) }.to change(question.answers, :count).by(1)
      end

      it 'saves file to db' do
        answers_create_request(question, files: true)
        expect(assigns(:answer).files.first.blob.filename).to eq('test_file.txt')
      end

      it 'renders question page' do
        answers_create_request(question)
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'creates answer' do
        expect { answers_create_request(question, body: nil, turbo_stream: false) }.to_not change(question.answers, :count)
      end

      it 're-renders question`s` show page' do
        answers_create_request(question, body: nil, turbo_stream: false)
        expect(response).to render_template 'questions/show'
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'finds answer' do
      delete :destroy, params: {id: answer, question_id: answer.question_id}, as: :turbo_stream
      expect(assigns(:answer)).to eq(answer)
    end

    context 'user`s own answer' do
      it 'deletes answer' do
        answer
        expect { delete :destroy, params: {id: answer.id, question_id: question.id}, as: :turbo_stream }.to change(question.answers, :count).by(-1)
      end
  end
    context 'other user`s answer' do
      it 'doesn`t delete answer' do
        authors_answer
        expect { delete :destroy, params: {id: authors_answer.id, question_id: question.id} }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'GET #edit' do
    before {  get :edit, params: { id: answer.id, question_id: answer.question_id } }

    it 'renders edit' do
      expect(assigns(:answer)). to eq answer
    end

    it 'finds answer' do
      expect(assigns(:answer)).to eq(answer)
    end
  end

  describe 'PUT #update' do
    it 'finds answer' do
      answers_update_request(answer)
      expect(assigns(:answer)).to eq(answer)
    end

    context 'with valid attributes' do
      context 'user`s own answer' do
        before { answers_update_request(answer) }

        it 'updates answer' do
          expect(Answer.first.body).to eq('Changed body')
        end

        it 'redirects to question`s show' do
          expect(response).to redirect_to(question_path(question))
        end
      end

      context 'other`s answer' do
        before { answers_update_request(authors_answer) }

        it 'doesn`t update answer' do
          expect(Answer.first.body).to_not eq('Changed body')
        end

        it 'redirects to question`s show' do
          expect(response).to redirect_to(question_path(authors_question))
        end
      end
    end

    context 'with invalid attributes' do
      before { answers_update_request(answer, nil) }

      it 'doesn`t update answer' do
        expect(Answer.first.body).to_not eq('Changed body')
      end

      it 're-renders edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #choose_best' do
    it 'finds answer and question' do
      post :choose_best, params: {id: answer.id, question_id: answer.question_id}, as: :turbo_stream
      expect(assigns(:answer)).to eq(answer)
      expect(assigns(:question)).to eq(question)
    end

    context 'question`s author' do
      let(:answers) { create_list(:answer, 3, question_id: question.id, user_id: user.id) }
      before { answers; post :choose_best, params: {id: answer.id, question_id: answer.question_id}, as: :turbo_stream }

      it 'selects answer as best' do
        expect(Question.first.best_answer).to eq(answer)
      end

      it 'renders choose_best question`s show' do
        expect(response).to render_template :choose_best
      end
    end

    context 'other user' do
      let(:authors_answers) { create_list(:answer, 3, question_id: authors_question.id, user_id: author.id) }
      before { authors_answers; post :choose_best, params: {id: authors_answer.id, question_id: authors_answer.question_id}, as: :turbo_stream }

      it 'doesn`t select answer as best' do
        expect(Question.first.best_answer).to_not eq(authors_answer)
      end

      it 'redirects to question`s show' do
        expect(response).to redirect_to(question_path(authors_question))
      end
    end
  end

  describe 'DELETE #delete_best' do
    context 'author`s own question' do
      before do
        question.best_answer = answer
        question.save
      end

      it 'finds answer and question' do
        delete :delete_best, params: {id: answer.id, question_id: question.id}
        expect(assigns(:answer)).to eq(answer)
        expect(assigns(:question)).to eq(question)
      end

      it 'deletes best answer' do
        delete :delete_best, params: {id: answer.id, question_id: question.id}
        expect(assigns(:question).best_answer).to eq(nil)
      end
    end

    context 'other`s question' do
      before do
        authors_question.best_answer = authors_answer
        authors_question.save
      end

      it 'doesn`t delete answer' do
        delete :delete_best, params: {id: authors_answer.id, question_id: authors_question.id}
        expect(expect(assigns(:question).best_answer).to eq(authors_answer))
      end
    end
  end

  describe 'POST #vote' do
    it 'finds answer' do
      answers_vote_request(authors_answer)
      expect(assigns(:answer)).to eq(authors_answer)
    end
    context 'user tries to like for other`s answer once' do
      it 'saves vote to db' do
        expect { answers_vote_request(authors_answer) }.to change(authors_answer, :rate).by(1)
      end

      it 'renders vote' do
        answers_vote_request(authors_answer)
        expect(response).to render_template :vote
      end
    end

    context 'user tries to dislike for other`s answer once' do
      it 'saves vote to db' do
        expect { answers_vote_request(authors_answer, 'disliked') }.to change(authors_answer, :rate).by(-1)
      end
    end

    context 'user tries to vote for other`s answer twice' do
      it 'saves only one vote to a db' do
        expect { answers_vote_request(authors_answer) }.to change(authors_answer, :rate).by(1)
        expect { answers_vote_request(authors_answer) }.to_not change(authors_answer, :rate)
      end 
    end

    context 'user tries to vote for his own answer' do
      it 'dosen`t vote like to db' do
        expect { answers_vote_request(answer) }.to_not change(answer, :rate)
      end
    end
  end
end
