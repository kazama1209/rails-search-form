class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.date :birthdate
      t.integer :prefecture_id

      t.timestamps
    end
  end
end
