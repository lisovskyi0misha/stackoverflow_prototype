module Api
  module V1
    class ApiController < ApplicationController
      before_action :doorkeeper_authorize!
    end
  end
end
