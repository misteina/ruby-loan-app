class LoginController < ApplicationController
    def action
        if cookie.signed[:tis]

            phone = params[:phone]
            password = param[:password]

            errors = []
            if phone.length != 11
                errors.push('Invalid phone number')
            end
            if password.length > 50 || password.length < 3
                errors.push('Invalid password')
            end

            if errors.length == 0
                query = 'SELECT password FROM register WHERE phone = ?'
                dataArray = [query, phone]
                sanitizedQuery = ActiveRecord::Base.send(:sanitize_sql_array, dataArray)
                result = ActiveRecord::Base.connection.select_one(sanitizedQuery)

                if result.length == 1
                    if BCrypt::Password.new(result[:password]) == password
                        render json: {success: 'done'}
                    else
                        render json: {error: 'Incorrect login credentials'}
                    end
                else
                    render json: {error: 'Not registered'}
                end
            else
                render json: {error: errors}
            end
        end
    end
end