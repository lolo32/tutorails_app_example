class AddSelToUtilisateurs < ActiveRecord::Migration
  def change
    add_column :utilisateurs, :sel, :string
  end
end
