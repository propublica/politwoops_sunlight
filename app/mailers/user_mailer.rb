class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def suggest_politician(politician, name, email)
  	recipients 'info@kelmetak.com'
  	from user.mail
  	subject "politician suggestion"
  	body :politician => politician
  end

end
