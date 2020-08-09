class LoginController < ApplicationController
    skip_before_action :require_login
    before_action :check_login

    def action

    end

    private
    def check_login
        if  cookies.signed[:wdt]
            @error = Hash["error" => "Illegal"]
            render json: @error
        end
    end
end