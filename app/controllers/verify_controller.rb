require 'net/http'

class VerifyController < ApplicationController
    def action

        phoneNumber = params[:phoneNumber]
        userName = 'smsglobal username'
        password = 'smsglobal password'
        from = 'sender number'
        otp = Random.new.rand(104673..997463)
        message = "Welcome to RedRock Finance, your verification code is #{otp}. Use this to complete your registration. We look forward to serving you!"

        uri = URI("https://api.smsglobal.com/http-api.php?action=sendsms&user=#{userName}&password=#{password}&from=#{from}&to=#{phoneNumber}&text=#{message}")
        res = Net::HTTP.get_response(uri)

        if res.code == 'OK: 0'
            render json: {success: 'done'}
        else
            render json: {error: 'failed'}
        end
    end
end