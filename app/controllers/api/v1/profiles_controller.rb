module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :doorkeeper_authorize!
      before_action :collect_users, only: :all

      def me
        render json: current_resource_owner
      end

      def all
        render json: @users_hash
      end

      private

      def collect_users
        @users_hash = {}
        User.all.each { |user| @users_hash["user_#{user.id}".to_sym] = user }
        @users_hash.delete(("user_#{current_resource_owner.id}".to_sym))
      end

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
