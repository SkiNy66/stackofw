module Likable
  extend ActiveSupport::Concern
  included do
    has_many :likes, as: :likable, dependent: :destroy

    def like_like(user)
      likes.find_or_create_by(user: user).update!(type_vote: 'Like')
    end

    def like_dislike(user)
      likes.find_or_create_by(user: user).update!(type_vote: 'Dislike')
    end

    def like_cancel(user)
      likes.find_by(user: user).destroy
    end

    def like_rating
      likes.where(type_vote: 'Like').count - likes.where(type_vote: 'Dislike').count
    end
  end
end
