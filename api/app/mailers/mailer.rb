# Mailer
class Mailer < ActionMailer::Base
  default from: 'info@kidsboards.org'

  # Sends email to confirm email
  # @param [String] email
  # @param [String] code
  def confirmation_email(email, code)
    @url = ENV['SITE_CONFIRM_LINK'] + '/' + code
    mail(to: email, subject: 'Thanks for registration at Kids Boards!')
  end

  # Sends email to recovery password
  # @param [String] email
  # @param [String] code
  def recovery_email(email, code)
    @url = ENV['SITE_RECOVERY_LINK'] + '/' + code
    mail(to: email, subject: 'Password recovery request at Kids Boards')
  end
end
