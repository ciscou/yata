class AddCategoryNameToTasks < ActiveRecord::Migration
  class Category < ActiveRecord::Base
  end

  class Task < ActiveRecord::Base
    belongs_to :category
  end

  def up
    add_column :tasks, :category_name, :string

    Task.all.each do |task|
      category = task.category
      task.update_attributes! category_name: category.name if category
    end
  end

  def down
    remove_column :tasks, :category_name
  end
end
