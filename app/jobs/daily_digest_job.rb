class DailyDigestJob < ActiveJob::Base
  queue_as :mailers

  def perform
    User.find_each { |user| DailyDigestMailer.digest(user).deliver_later }
  end
end