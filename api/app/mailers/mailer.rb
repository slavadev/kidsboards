# Mailer
class Mailer < ActionMailer::Base
  default from: 'notifications@example.com'

  # Sends email to confirm email
  # @param [String] email
  # @param [String] code
  def confirmation_email(email, code)
    @url = ENV['SITE_CONFIRM_LINK'] + '/' + code
    mail(to: email, subject: 'Thanks for registration in That\'s a boy!')
  end

  # Sends email to recovery password
  # @param [String] email
  # @param [String] code
  def recovery_email(email, code)
    @url = ENV['SITE_RECOVERY_LINK'] + '/' + code
    mail(to: email, subject: 'Password recovery request in That\'s a boy!')
  end
end
