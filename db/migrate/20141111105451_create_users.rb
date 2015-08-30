class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.date :birth_date
      t.float :weight
      t.float :height
      t.string :gender

      t.timestamps null: false
    end
  end
end
