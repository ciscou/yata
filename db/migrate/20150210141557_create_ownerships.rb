class CreateOwnerships < ActiveRecord::Migration
  class Task < ActiveRecord::Base
  end

  class Ownership < ActiveRecord::Base
  end

  def up
    create_table :ownerships do |t|
      t.references :user, index: true
      t.references :task, index: true

      t.timestamps
    end

    Task.find_each do |task|
      Ownership.create! user_id: task.user_id, task_id: task.id
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "cannot reassociate tasks to former owners"
  end
end
