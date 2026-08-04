class Tag < ApplicationRecord
  belongs_to :user
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags
  validates :name, uniqueness: { scope: :user_id }, presence: true
end
