require 'date'

class LoanapplicationController < ApplicationController
    def action
        if cookie.signed[:tis]

            amount = params[:amount].to_i
            duration = params[:duration]

            errors = []
            dateFormat = Date.strptime(duration, '%d-%m-%Y') rescue false
            allowFigures = [2500, 5000, 10000, 20000, 40000, 80000, 100000, 120000, 150000]

            if !allowFigures.include? amount
                errors.push('Invalid amount')
            end
            if !dateFormat
                errors.push('Invalid loan tenure date')
            end

            if errors.length == 0
                duration = Date.parse("20120225").strftime("%Y-%m-%d")
                userId = cookie.signed[:tis]

                query = 'INSERT INTO employment (uid, amount, dueDate) VALUES (?, ?, ?)'
                dataArray = [query, userId, amount, duration]
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