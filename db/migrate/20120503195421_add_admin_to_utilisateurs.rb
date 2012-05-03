class AddAdminToUtilisateurs < ActiveRecord::Migration
  def change
    add_column :utilisateurs, :admin, :boolean, :default => false
  end
end
