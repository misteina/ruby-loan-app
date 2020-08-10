class CsrftokenController < ApplicationController
    def action
        token = {token: form_authenticity_token}
        render json: token
    end
end