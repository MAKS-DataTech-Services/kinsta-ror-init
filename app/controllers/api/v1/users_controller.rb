# frozen_string_literal: true

include ActionView::Helpers::SanitizeHelper
# include ApiHelper
# include ApplicationHelper

class Api::V1::UsersController < Api::V1::ApiController
    skip_before_action :authenticate
    skip_before_action :verify_authenticity_token
    before_action :set_user, only: [:send_verification, :set_otp_receiver, :verify]
    # before_action :set_twilio_client, only: [:send_verification, :verify]

    layout "api_gray"

    def show_info
        current_user = { id: 1, name: 'Maksdts' }
        render json: current_user, status: :ok
    end
end