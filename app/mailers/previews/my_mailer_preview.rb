# Preview all emails at http://localhost:3000/rails/mailers/my_mailer
class MyMailerPreview < ActionMailer::Preview

  def welcome_email
    MyMailer.welcome_email('user@example.com')
  end
end
