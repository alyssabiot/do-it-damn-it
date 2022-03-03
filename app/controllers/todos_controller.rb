class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy update_category]
  before_action :set_categories

  def index
    if params[:category_id].present?
      @todos = current_user.todos.where(category_id: params[:category_id]).order(created_at: :desc)
      @title = Category.find(params[:category_id]).name
    else
      @todos = current_user.todos.where(category_id: nil).order(status: :asc, created_at: :desc)
      @title = "Uncategorized"
    end
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def edit
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    respond_to do |format|
      if @todo.save
        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
  respond_to do |format|
    if @todo.update(todo_params)
      format.turbo_stream
      format.html { redirect_to todo_url(@todo), notice: "Todo was successfully updated." }
      format.json { render :show, status: :ok, location: @todo }
    else
      format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @todo.errors, status: :unprocessable_entity }
    end
  end
end

  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_category
    @todo.update(category_id: todo_params[:category_id])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todo_url(@todo), notice: "Todo was successfully updated." }
      format.json { render :show, status: :ok, location: @todo }
    end
  end

  private
    def set_todo
      @todo = Todo.find(params[:id])
    end

    def set_categories
      @categories = current_user.categories.all.order(created_at: :desc)
    end

    def todo_params
      params.require(:todo).permit(:name, :status, :category_id)
    end
end
