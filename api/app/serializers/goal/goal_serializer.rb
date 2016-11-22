# Describes how to show a goal with full info
class Goal::GoalSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url, :target, :current, :created_at
  has_many :actions, unless: -> { context == :index }
end