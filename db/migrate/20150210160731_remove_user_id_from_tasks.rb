class RemoveUserIdFromTasks < ActiveRecord::Migration
  def up
    remove_reference :tasks, :user
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
