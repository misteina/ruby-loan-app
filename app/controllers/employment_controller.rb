class EmploymentController < ApplicationController
    def action
        if cookie.signed[:tis]

            employment = params[:employment]
            company = params[:company]
            income = params[:income]
            employmentDate = params[:employmentDate]
            companyAddress = params[:companyAddress]
            state = params[:state]
            city = params[:city]

            errors = []
            if employment != 'employed' && employment != 'self' && employment != 'unemployed'
                errors.push('Invalid employment information')
            end
            if company.length > 45 || company.length < 2
                errors.push('Invalid company name')
            end
            if !income.scan(/\D/).empty?
                errors.push('Invalid income amount. Only numbers allowed')
            end
            if !employmentDate.match(/^(0[1-9]|[12][0-9]|3[01])[- \/.](0[1-9]|1[012])[- \/.](19|20)\d\d$/)
                errors.push('Invalid employment date')
            end
            if companyAddress.length < 5
                errors.push('Invalid company address')
            end
            if !states.include? state
                errors.push('Invalid state')
            end
            if city.length > 3
                errors.push('Invalid city')
            end

            if errors.length == 0
                userId = cookie.signed[:tis]
                query = 'INSERT INTO employment (uid, employment, company, income, employmentDate, companyAddress, state, city) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
                dataArray = [query, userId, employed, company, income, employmentDate, companyAddress, state, city]
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