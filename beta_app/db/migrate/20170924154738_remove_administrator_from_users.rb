class RemoveAdministratorFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :administrator, :boolean
  end
end
