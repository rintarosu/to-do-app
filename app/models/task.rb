class Task < ApplicationRecord
  validates :title, presence: true
  validate :parent_depth_within_limit
  validate :children_must_be_completed, if: -> { completed? && completed_changed? }

  belongs_to :user
  belongs_to :parent, class_name: "Task", optional: true
  has_many :children, class_name: "Task", foreign_key: :parent_id, dependent: :restrict_with_error

  has_many :ancestor_links, class_name: "TaskClosure", foreign_key: :descendant_id, dependent: :delete_all
  has_many :descendant_links, class_name: "TaskClosure", foreign_key: :ancestor_id, dependent: :delete_all
  has_many :ancestors, through: :ancestor_links, source: :ancestor
  has_many :descendants, through: :descendant_links, source: :descendant

  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  after_create :create_closure_records

  private

  def create_closure_records
    TaskClosure.create!(ancestor: self, descendant: self, depth: 0)

    return if parent.nil?

    parent.ancestor_links.each do |link|
      TaskClosure.create!(ancestor_id: link.ancestor_id, descendant: self, depth: link.depth + 1)
    end
  end

  def parent_depth_within_limit
    return if parent.nil?
    if parent.ancestor_links.count > 4
      errors.add(:parent, "これ以上分解できません")
    end
  end

  def children_must_be_completed
    if children.any? { |c| !c.completed? }
      errors.add(:task, "完了していないサブタスクがあります")
    end
  end
end
