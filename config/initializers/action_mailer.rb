Rails.application.config.action_mailer.delivery_method = :smtp

Rails.application.config.action_mailer.smtp_settings = {
  address:              'smtp.163.com',
  port:                 25,
  domain:               '163.com',
  user_name:            Settings.smtp_settings.user_name,
  password:             Settings.smtp_settings.password,
  authentication:       'plain',
  enable_starttls_auto: true
}
