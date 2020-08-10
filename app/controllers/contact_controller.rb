class ContactController < ApplicationController
    def action
        if cookie.signed[:tis]

            name = params[:name]
            email = params[:email]
            subject = params[:subject]
            body = params[:body]

            errors = [];
            if !name.match(/\A[a-z\s]+\Z/i) || name.length > 40 || name.length < 3
                errors.push('Name is invalid')
            end
            if !email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
                errors.push('Email address is invalid')
            end
            if subject.length < 3
                errors.push('Fill the message subject')
            end
            if body.length < 3
                errors.push('Fill the message body')
            end

            if errors.length == 0
                userId = cookie.signed[:tis]
                query = 'SELECT firstName FROM PersonalDetails WHERE uid = ?'
                sanitizedQuery = ActiveRecord::Base.send(:sanitize_sql_array, [query, userId])
                data = ActiveRecord::Base.connection.select_one(sanitizedQuery)

                if data.key?(:firstName)
                    senderName = data[:firstName]
                    senderEmail = email
                    ContactMailer.send(senderName, senderEmail).deliver_now

                    render json: {success: 'Sent'}
                else
                    render json: {error: 'user not found'}
                end
            else
                render json: {error: errors}
            end
        else
            render json: {error: 'Not authorized'}
        end
    end
end