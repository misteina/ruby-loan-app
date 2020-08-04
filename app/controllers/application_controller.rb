class ApplicationController < ActionController::Base
    before_action :require_login

    private
    def require_login
        unless logged_in?
            @error = Hash["error" => "Not logged in"]
            render json: @error
        end
    end
end
