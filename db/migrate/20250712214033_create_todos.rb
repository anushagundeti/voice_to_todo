class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :content
      t.references :audio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
