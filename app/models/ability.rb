# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    return unless user.present?

    can :create, :all
    can :update, :all, user: user
    can :destroy, :all, user: user
    can :choose_best, Answer, question: { user: }
    can :delete_best, Answer, question: { user: }
    can :vote, :all
    cannot :vote, :all, { user: }
    can :new_for_answer, Comment
    can :new_for_question, Comment
  end
end
