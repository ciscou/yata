class RemoveCategoryIdFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :category_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
