# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController
    include Rails::Pagination
  
    skip_before_action :check_user_status
    skip_before_action :configure_permitted_parameters, if: :devise_controller?
  
    respond_to :json
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
    before_action :authenticate
  
    def authenticate
      # if we already found the user by toke in tagged_logging.rb, use that
      if request.env['api_authenticated_user']
        @current_user = request.env['api_authenticated_user']
        return
      end
      @current_user = current_user
      if request.headers['Authorization']
        @current_user = User.find_by(authentication_token: request.headers['Authorization'])
      elsif params[:Authorization]
        @current_user = User.find_by(authentication_token: params[:Authorization])
      elsif params[:impact_jwt] && ImpactJwt.decode(params[:impact_jwt])
        @current_user = User.new # don't log them in as someone else, but also don't kick them out. It is expected that the actual auth will happen in the controller
      elsif !@current_user
        return render json: { errors: "Invalid authorization token." }, status: 422
      end
      puts "-----------------#{current_user}"
      if !@current_user
        if (request.headers['Authorization'].presence || params[:Authorization].presence) == Rails.application.secrets.recovery_api_key
          @current_user = User.first
        else
          render json: { errors: "Invalid authorization token!" }, status: 422
        end
      end
    end
  
    def record_not_found
      render json: { errors: "The targeted records were not found." }, status: 422
    end
  
    def switch_user_role
      if params[:role].present? && current_user.allowed_roles && current_user.allowed_roles.include?(params[:role])
        current_user.update(roles: params[:role])
      end
    end
  
    helper_method :wd
  end