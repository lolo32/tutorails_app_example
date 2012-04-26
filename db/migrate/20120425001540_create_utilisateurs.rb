class CreateUtilisateurs < ActiveRecord::Migration
  def change
    create_table :utilisateurs do |t|
      t.string :nom
      t.string :courriel

      t.timestamps
    end
  end
end
