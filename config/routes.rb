Rails.application.routes.draw do
    
    get '/csrftoken', to: 'csrftoken#action' 
    post '/verification-code', to: 'verify#action'
    post '/register', to: 'register#action'
    post '/login', to: 'login#action'
    post '/personal-details', to: 'personaldetails#action'
    post '/employment', to: 'employment#action'
    post '/account-details', to: 'accountdetails#action'
    post '/loan-application', to: 'loanapplication#action'
    post '/contact', to: 'contact#action'
    match '*all', to: 'nomatch#action', via: :all
    
end
