class ContactMailer < ActionMailer::Base
    def send(senderName, senderEmail)
        mail(to: 'contact@redrockfinance.com', from: senderEmail, subject: 'New Contact Message From ' + senderName)
    end
end