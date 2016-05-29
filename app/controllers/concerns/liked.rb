module Liked
  extend ActiveSupport::Concern
  included do

    before_action :gets_likable, only: [:like_like, :like_dislike, :like_cancel]
    before_action :check_owner, only: [:like_like, :like_dislike, :like_cancel]

    def like_like
      @likable.like_like(current_user)
      render json: { rating: @likable.like_rating, likable_id: @likable.id }
    end

    def like_dislike
      @likable.like_dislike(current_user)
      render json: { rating: @likable.like_rating, likable_id: @likable.id }
    end

    def like_cancel
      @likable.like_cancel(current_user)
      render json: { rating: @likable.like_rating, likable_id: @likable.id }
    end

  private

    def check_owner
      if user_signed_in?
        if @likable.user_id == current_user.id
          render nothing: true, status: 403
        end
      end
    end

    def gets_likable
      @likable = model_klass.find(params[:id])
    end

    def model_klass
      controller_name.classify.constantize
    end
  end
end
