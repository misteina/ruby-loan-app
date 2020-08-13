class RegisterController < ApplicationController
    def action
        
        if session[:verificationCode]
            verificationCode = params[:verificationCode]
            bvn = params[:bvn]
            password = params[:password]
            confirmPassword = params[:confirmPassword]

            errors = []
            password = password.gsub(/\s+/, '')

            if verificationCode != session[:verificationCode]
                errors.push('Invalid verification code')
            end
            if !bvn.match(/[0-9]+/)
                errors.push('Invalid BVN')
            end
            if password.length < 4 || password.length > 30
                errors.push('Password not accepted')
            end
            if password != confirmPassword
                errors.push('Password mismatch')
            end

            if errors.length == 0
                query = 'INSERT INTO register (bvn, password) VALUES (?, ?)'
                dataArray = [query, bvn, passowrd]
                sanitizedQuery = ActiveRecord::Base.send(:sanitize_sql_array, dataArray)
                result = ActiveRecord::Base.connection.update(sanitizedQuery)

                if result == 1
                    render json: {error: 'success'}
                else
                    render json: {error: 'failed'}
                end
            else
                render json: {error: errors}
            end
        else
            render json: {error: 'Verification code is invalid'}
        end
    end
end
