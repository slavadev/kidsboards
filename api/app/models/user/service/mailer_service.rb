# Contains methods to work with emails
class User::Service::MailerService
  # Sends an email with confirmation code to user
  # @param [String] email
  # @param [String] code
  def send_confirmation(email, code)
    Mailer.confirmation_email(email, code).deliver_later
  end

  # Sends an email with recovery code to user
  # @param [String] email
  # @param [String] code
  def send_recovery(email, code)
    Mailer.recovery_email(email, code).deliver_later
  end
end
