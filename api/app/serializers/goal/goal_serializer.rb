class Goal::GoalSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url, :target, :current, :created_at
  has_many :actions, serializer: Goal::ActionSerializer
end