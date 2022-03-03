class CategoriesController < ApplicationController
  def create
    @category = Category.new(category_params)
    @category.user = current_user

    respond_to do |format|
      if @category.save
        format.turbo_stream
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@category)}_form", partial: "form", locals: { category: @category }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
  def category_params
    params.require(:category).permit(:name, :status)
  end
end
