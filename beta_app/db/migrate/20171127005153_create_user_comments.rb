class CreateUserComments < ActiveRecord::Migration[5.1]
  def change
    create_table :user_comments do |t|
      t.integer :author_id
      t.integer :mentioned_id
      t.text :comment

      t.timestamps
    end
  end
end
