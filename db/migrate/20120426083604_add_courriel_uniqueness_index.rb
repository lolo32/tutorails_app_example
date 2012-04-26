class AddCourrielUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :utilisateurs, :courriel, :unique => true
  end

  def down
    remove_index :utilisateurs, :courriel
  end
end
