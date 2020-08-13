require 'date'

class PersonaldetailsController < ApplicationController
    def action
        if cookie.signed[:tis]

            firstName = params[:firstName]
            lastName = params[:lastName]
            email = params[:email]
            dateOfBirth = params[:dateOfBirth]
            sex = params[:sex]
            maritalStatus = params[:maritalStatus]
            dependents = params[:dependents]
            address = params[:address]
            state = params[:state]
            city = params[:city]

            errors = []
            dateFormat = Date.strptime(dateOfBirth, '%d-%m-%Y') rescue false

            if (!firstName.match(/^[[:alpha:]]+$/) || (firstName.length > 40 && firstName.length < 2))
                errors.push('Invalid first name')
            end
            if (!lastName.match(/^[[:alpha:]]+$/) || (lastName.length > 40 && lastName.length < 2))
                errors.push('Invalid last name')
            end
            if !email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
                errors.push('Email address is invalid')
            end
            if !dateFormat
                errors.push('Invalid date of birth')
            end
            if sex != 'male' && sex != 'female'
                errors.push('Invalid gender')
            end
            if maritalStatus != 'single' && maritalStatus != 'married'
                errors.push('Invalid marital status')
            end
            if !dependents.match(/[0-9]+/)
                errors.push('Invalid number of dependents')
            end
            if !address.match(/^[a-zA-Z0-9\,\.'\-]+$/)
                errors.push('Invalid address')
            end
            if !state.match(/^[a-zA-Z]+$/)
                errors.push('Invalid state')
            end
            if !city.match(/^[a-zA-Z\s]+$/)
                errors.push('Invalid address')
            end

            if errors.length == 0
                dateOfBirth = Date.parse(dateOfBirth).strftime("%Y-%m-%d")
                userId = cookie.signed[:tis].to_i

                query = 'INSERT INTO PersonalDetails (uid, firstName, lastName, email, dateOfBirth, sex, maritalStatus, dependents, address, state, city) VALUES (?, ?, ?,?,?,?,?,?,?,?,?)'
                dataArray = [query, userId, firstName, lastName, email, dateOfBirth, sex, maritalStatus, dependents, address, state, city]
                sanitizedQuery = ActiveRecord::Base.send(:sanitize_sql_array, dataArray)
                result = ActiveRecord::Base.connection.update(sanitizedQuery)

                if result == 1
                    render json: {success: 'done'}
                else
                    render json: {error: 'failed'}
                end
            else
                render json: {error: errors}
            end
        else
            render json: {error: 'Not authorized'}
        end
    end
end