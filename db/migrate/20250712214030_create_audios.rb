class CreateAudios < ActiveRecord::Migration[8.0]
  def change
    create_table :audios do |t|
      t.string :file
      t.text :transcript

      t.timestamps
    end
  end
end
