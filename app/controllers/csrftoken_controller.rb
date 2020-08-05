class CsrftokenController < ApplicationController
    skip_before_action :require_login

    def action
        @token = Hash['token' => form_authenticity_token]
        render json: @token
    end
end