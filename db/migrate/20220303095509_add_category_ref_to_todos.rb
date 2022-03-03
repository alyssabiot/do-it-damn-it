class AddCategoryRefToTodos < ActiveRecord::Migration[7.0]
  def change
    add_reference :todos, :category, foreign_key: true, on_delete: :nullify
  end
end
