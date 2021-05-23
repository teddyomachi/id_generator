class CreateIdGenerations < ActiveRecord::Migration[5.2]
  def change
    create_table :id_generations do |t|
      t.string :uid_base
      t.string :password_base
      t.string :altid_base
      t.boolean :withdrawn
      t.timestamp :wddate

      t.timestamps
    end
  end
end
