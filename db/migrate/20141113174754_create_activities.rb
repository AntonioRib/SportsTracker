class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.datetime :date
      t.integer :place_id
      t.integer :sport_id
      t.integer :owner_id
      t.text :points
    end
  end
end
