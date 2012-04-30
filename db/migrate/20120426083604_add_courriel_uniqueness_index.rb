class AddCourrielUniquenessIndex < ActiveRecord::Migration
  def change
    add_index :utilisateurs, :courriel, :unique => true
  end
end
