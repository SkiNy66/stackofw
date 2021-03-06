class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User, id: user.id
    can :users, User
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer, Subscription], user_id: user.id
    can :destroy, Attachment, attachmentable: { user_id: user.id }
    can :mark_best, Answer, question: { user_id: user.id }
    can [:like_up, :like_down, :like_cancel], [Question, Answer] { |likable| likable.user_id != user.id }
  end
end
