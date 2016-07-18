class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Time.now.yesterday.all_day)
    mail(to: user.email, subject: 'Questions daily digest')
  end
end
