class MyMailer < ApplicationMailer
  default from: Settings.mailer.default_from

  def welcome_email(user_email)
    user_email = user_email.present? ? user_email : Settings.mailer.default_to
    mail(to: user_email, subject: 'Welcome')
  end
end
