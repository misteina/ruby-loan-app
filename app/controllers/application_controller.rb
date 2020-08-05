class ApplicationController < ActionController::Base
    before_action :require_login

    private
    def require_login
        if  !cookies.signed[:wdt]
            @error = Hash["error" => "unkown"]
            render json: @error
        end
    end
end
