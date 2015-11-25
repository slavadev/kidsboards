# Mailer
class Mailer < ActionMailer::Base
  default from: 'notifications@example.com'

  # Send email to confirm email
  # @param [String] email
  # @param [String] code
  def confirmation_email(email, code)
    @url  = ENV['SITE_HOST'] + '/api/v1/user/confirm/' + code
    mail(to: email, subject: 'Спасибо за регистрацию на That\'s a boy!')
  end

  # Send email to recovery password
  # @param [String] email
  # @param [String] code
  def recovery_email(email, code)
    @url  = ENV['SITE_RECOVERY_LINK'] + '/' + code
    mail(to: email, subject: 'Запрос на смену пароля на That\'s a boy!')
  end
end
