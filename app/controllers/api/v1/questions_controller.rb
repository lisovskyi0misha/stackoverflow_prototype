module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :find_question, only: :show

      def index
        render json: collected_questions
      end

      def show
        render json: { question: @question, comments: @question.comments, files: @question.file_urls }
      end

      def create
        @question = Question.create(question_params)
        render check_question
      end

      private

      def check_question
        @question.valid? ? { json: @question } : { json: { message: @question.errors.full_messages.join("\n") }, status: 422 }
      end

      def collected_questions
        Question.all.collect { |question| ["question_#{question.id}".to_sym, question] }.to_h
      end

      def find_question
        @question = Question.includes(:comments, :comments).find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body, :user_id)
      end
    end
  end
end
