# Describes how to show a short version of goal's info
class Goal::GoalShortSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url, :target, :current, :created_at
end