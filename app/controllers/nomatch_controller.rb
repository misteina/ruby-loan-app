class NomatchController < ApplicationController
    skip_before_action :require_login
    
    def action
        render json: Hash['error' => '404']
    end
end