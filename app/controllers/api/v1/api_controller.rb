module Api
  module V1
    class ApiController < ApplicationController
      before_action :doorkeeper_authorize!

      private

      def check_singe_resource_validness
        name = self.class.to_s.split('::').last.delete_suffix('sController').downcase
        object = instance_variable_get("@#{name}".to_sym)
        object.valid? ? { json: object } : { json: { message: object.errors.full_messages.join("\n") }, status: 422 }
      end
    end
  end
end
