class AddMdpToUtilisateurs < ActiveRecord::Migration
  def change
    add_column :utilisateurs, :mdp_chiffre, :string
  end
end
