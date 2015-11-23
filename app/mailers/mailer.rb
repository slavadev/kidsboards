# Mailer
class Mailer < ActionMailer::Base
  default from: 'notifications@example.com'

  # Send email to confirm email
  # @param [Hash] params
  def confirmation_email(params)
    @url  = ENV['SITE_HOST'] + '/api/v1/user/confirm/' + params[:code]
    mail(to: params[:email], subject: 'Спасибо за регистрацию на That\'s a boy!')
  end
end
