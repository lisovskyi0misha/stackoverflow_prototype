module Api
  module V1
    class ApiController < ApplicationController
      before_action :doorkeeper_authorize!

      private

      def check_singe_resource_validness
        object.valid? ? render_object : render_error
      end

      def single_resource_name
        self.class.to_s.split('::').last.delete_suffix('sController').downcase
      end

      def object
        @object ||= instance_variable_get("@#{single_resource_name}".to_sym)
      end

      def render_object
        { json: @object }
      end

      def render_error
        { json: { message: @object.errors.full_messages.join("\n") }, status: 422 }
      end
    end
  end
end
