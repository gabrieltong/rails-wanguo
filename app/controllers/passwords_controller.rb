class PasswordsController < Clearance::PasswordsController
  def deliver_email(user)
    ClearanceMailer.delay.change_password(user)
  end
end