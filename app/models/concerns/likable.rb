module Likable
  extend ActiveSupport::Concern
  included do
    has_many :likes, as: :likable, dependent: :destroy

    def like_like(user)
      self.likes.find_or_create_by(user: user).update!(type_vote: 'Like')
    end

    def like_dislike(user)
      self.likes.find_or_create_by(user: user).update!(type_vote: 'Dislike')
    end

    def like_cancel(user)
      self.likes.find_by(user: user).destroy
    end

    def like_rating
      (self.likes.where(type_vote: 'Like').count)-(self.likes.where(type_vote: 'Dislike').count)
    end
  end
end
