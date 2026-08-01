class TaskClosure < ApplicationRecord
  belongs_to :ancestor, class_name: "Task"
  belongs_to :descendant, class_name: "Task"
end
