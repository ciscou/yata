class CategoriesController < ApplicationController
  def index
    @categories = current_user.categories
  end

  def new
    @category = current_user.categories.new
  end

  def edit
    @category = current_user.categories.find(params[:id])
  end

  def create
    @category = current_user.categories.new(category_attributes)

    if @category.save
      redirect_to categories_url, notice: 'Category was successfully created.'
    else
      flash.now.alert = "Oops, failed to create category"
      render action: "new"
    end
  end

  def update
    @category = current_user.categories.find(params[:id])

    if @category.update_attributes(category_attributes)
      redirect_to categories_url, notice: 'Category was successfully updated.'
    else
      flash.now.alert = "Oops, failed to update category"
      render action: "edit"
    end
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy

    redirect_to categories_url, notice: "Category was successfully deleted"
  end

  private

  def category_attributes
    params.require(:category).permit!
  end
end
