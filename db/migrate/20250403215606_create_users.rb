class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :role, null: false
      t.uuid :clinic_id

      t.timestamps
    end

    add_index :users, :clinic_id
  end
end
