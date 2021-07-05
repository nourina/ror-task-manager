class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :status
      t.datetime :deadline
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
