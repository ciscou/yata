class CreateSubTasks < ActiveRecord::Migration
  def change
    create_table :sub_tasks do |t|
      t.references :task, index: true
      t.string :name
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
