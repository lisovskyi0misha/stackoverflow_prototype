module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      def index
        render json: collected_questions
      end

      private

      def collected_questions
        Question.all.collect { |question| ["question_#{question.id}".to_sym, question] }.to_h
      end
    end
  end
end
