module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :find_answers, only: :index
      before_action :find_answer, only: :show

      def index
        render json: @answers
      end

      def show
        render json: { answer: @answer, comments: @answer.comments, files: @answer.file_urls }
      end

      private

      def find_answers
        @answers = Answer.where(question_id: params[:question_id]).order(:id)
      end

      def find_answer
        @answer = Answer.includes(:comments).find(params[:id])
      end
    end
  end
end
