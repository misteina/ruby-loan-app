class AccountdetailsController < ApplicationController
    def action
        if cookie.signed[:tis]

            userId = cookie.signed[:tis]
            bank = params[:bank]
            accountNumber = params[:accountNumber]
            
            errors = []
            if !bank.match(/\A[a-z\s]+\Z/i) || bank.length > 40
                error.push('Bank account is invalid')
            end
            if !accountNumber.scan(/\D/).empty? || accountNumber.length > 10
                error.push('Bank account is invalid')
            end

            query = 'INSERT INTO AccountDetails (uid, bankName, accountNumber) VALUES (?, ?, ?)'
            sanitizedQuery = ActiveRecord::Base.send(:sanitize_sql_array, [query, userId, bankName, accountNumber])
            result = ActiveRecord::Base.connection.exec_query(query)

            render json: Hash['success' => 'done']
        else
            render json: Hash['error' => 'Not authorized']
        end
    end
end