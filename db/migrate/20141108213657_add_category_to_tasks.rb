class AddCategoryToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :category, index: true
  end
end
