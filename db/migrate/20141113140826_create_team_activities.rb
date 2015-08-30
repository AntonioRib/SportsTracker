class CreateTeamActivities < ActiveRecord::Migration
  def change
    create_table :team_activities do |t|
      t.integer :team_id
      t.integer :activity_id

      t.timestamps null: false
    end
  end
end
