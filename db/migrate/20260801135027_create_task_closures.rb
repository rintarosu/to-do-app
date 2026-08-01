class CreateTaskClosures < ActiveRecord::Migration[8.1]
  def change
    create_table :task_closures do |t|
      t.references :ancestor, null: false, foreign_key: { to_table: :tasks }
      t.references :descendant, null: false, foreign_key: { to_table: :tasks }
      t.integer :depth, null: false
    end

    add_index :task_closures, [ :ancestor_id, :descendant_id ], unique: true
  end
end
