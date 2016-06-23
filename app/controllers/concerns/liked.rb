module Liked
  extend ActiveSupport::Concern
  included do
    before_action :gets_likable, only: [:like_up, :like_down, :like_cancel]
    before_action :check_owner, only: [:like_up, :like_down, :like_cancel]

    def like_up
      authorize! :like_up, @likable
      @likable.like!(current_user)
      render json: { rating: @likable.like_rating, likable_id: @likable.id }
    end

    def like_down
      authorize! :like_down, @likable
      @likable.dislike!(current_user)
      render json: { rating: @likable.like_rating, likable_id: @likable.id }
    end

    def like_cancel
      authorize! :like_cancel, @likable
      @likable.like_cancel(current_user)
      render json: { rating: @likable.like_rating, likable_id: @likable.id }
    end

  private

    def check_owner
      if user_signed_in?
        render nothing: true, status: 403 if @likable.user_id == current_user.id
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
