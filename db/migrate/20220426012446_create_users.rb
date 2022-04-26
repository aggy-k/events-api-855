class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :open_id
      t.string :nickname
      t.string :avatar

      t.timestamps
    end
  end
end
