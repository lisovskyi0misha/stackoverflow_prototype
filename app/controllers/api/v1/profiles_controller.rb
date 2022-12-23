module Api
  module V1
    class ProfilesController < Api::V1::ApiController
      def me
        render json: current_resource_owner
      end

      def all
        render json: collected_users
      end

      private

      def collected_users
        User.except_user(current_resource_owner.id).collect { |user| ["user_#{user.id}".to_sym, user] }.to_h
      end

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
