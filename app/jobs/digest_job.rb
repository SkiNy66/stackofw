class DigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each { |user| DigestMailer.digest(user).deliver_later }
  end
end