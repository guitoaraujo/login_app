class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.integer :login_attempts, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
