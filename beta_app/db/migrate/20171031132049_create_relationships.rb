# Usuario sigue a usuario
class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :followed_id
      t.integer :follower_id

      t.timestamp
    end
  end
end
