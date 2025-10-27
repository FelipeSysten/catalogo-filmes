# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user, optional: true # Para permitir comentários anônimos

  validates :content, presence: true
  validates :name, presence: { if: -> { user_id.present? } } # Name é obrigatório se não for usuário logado
end