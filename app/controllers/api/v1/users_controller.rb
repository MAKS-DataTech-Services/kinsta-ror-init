# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::ApiController
    skip_before_action :authenticate
    skip_before_action :verify_authenticity_token
  
    def testing
        render json: {message: 'Great job, you found this endpoint!'}, status: :ok
    end
end