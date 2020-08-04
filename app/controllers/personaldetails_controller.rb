class PersonaldetailsController < ApplicationController
    def action
        @data = Hash["a" => 1,"b" => 2]
        render json: @data
    end
end