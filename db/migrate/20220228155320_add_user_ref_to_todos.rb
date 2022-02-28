class AddUserRefToTodos < ActiveRecord::Migration[7.0]
  def change
    add_reference :todos, :user, foreign_key: true
  end
end
