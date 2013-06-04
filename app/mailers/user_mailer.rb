class UserMailer < ActionMailer::Base
  default :from => "suggest@kelmetak.com", 
  		  :to => "info@kelmetak.com"
  
  def suggest_politician(politician, name, email)
  	@name = name
  	@email = email

  	@politician = politician
  	@url = 'http://2ad.kelmetak.com'
  	
  	mail(:to => "info@kelmetak.com", :subject => "Politician suggestion from #{name}")
  end

end
