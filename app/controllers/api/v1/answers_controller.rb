module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :find_answers, only: :index

      def index
        render json: @answers
      end

      private

      def find_answers
        @answers = Question.find(params[:question_id]).answers
      end
    end
  end
end
