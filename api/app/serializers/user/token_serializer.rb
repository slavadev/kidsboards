# Describes how to show a token
class User::TokenSerializer < ActiveModel::Serializer
  attribute :code, key: :token
end