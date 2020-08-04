class CsrftokenController < ApplicationController
    skip_before_action :require_login

    def action
        if request.headers.key?('clientApp')
            @token = Hash['token' => form_authenticity_token]
            render json: @token
        else
            render plain: 'Not Authorized'
        end
    end
end