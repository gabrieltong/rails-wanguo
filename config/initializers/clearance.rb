Clearance.configure do |config|
  config.cookie_expiration = lambda { 1.year.from_now.utc }
  config.httponly = false
  config.mailer_sender = 'reply@example.com'
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  # config.redirect_url = '/'
  config.secure_cookie = false
  config.user_model = User
end