class RenameCategoryNameToCategoryInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :category_name, :category
  end
end
