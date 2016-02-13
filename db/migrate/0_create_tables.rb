# Creates Tables
class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # basic attributes
      t.string :email
      t.string :hashed_password
    end
    add_index :users, :email, :unique => true

    create_table :tv_shows do |t|
      # basic attributes
      t.string :user
      t.string :name
      t.string :db_id
      t.string :season
      t.string :episode
      t.string :next_episodes
      t.string :pic
    end
    add_index :tv_shows, :user
  end
end
