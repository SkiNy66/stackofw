module Likable
  extend ActiveSupport::Concern
  included do
    has_many :likes, as: :likable, dependent: :destroy

    def like!(user)
      # likes.find_or_create_by(user: user).update!(type_vote: 'Like')
      likes.find_or_initialize_by(user: user).update!(type_vote: 1)
    end

    def dislike!(user)
      likes.find_or_initialize_by(user: user).update!(type_vote: -1)
    end

    def like_cancel(user)
      likes.find_by(user: user).destroy
    end

    def like_rating
      likes.sum(:type_vote)
    end
  end
end
