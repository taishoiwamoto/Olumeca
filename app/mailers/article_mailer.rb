class ArticleMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: 'h.m.tai.26@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end
