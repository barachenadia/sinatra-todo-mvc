class CreateTodos < ActiveRecord::Migration
  def up
    create_table :todos do |t|
      t.string :title
      t.text :content
    end
  end
end
