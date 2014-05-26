class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,         :null => false
      t.string :email,            :null => false
      t.string :crypted_password
      t.string :salt
      t.integer :role,              :null => false, :default => DEFAULT_ROLE
      t.string :first_name,         :null => true, :default => nil
      t.string :second_name,        :null => true, :default => nil
      t.boolean :blocked,           :null => false, :default => false
      t.datetime :block_expires_at, :null => true, :default => nil
      t.string :activation_state
      t.string :activation_token
      t.datetime :activation_token_expires_at
      t.string :reset_password_token,              :null => true, :default => nil
      t.datetime :reset_password_token_expires_at, :null => true, :default => nil
      t.datetime :reset_password_email_sent_at,    :null => true, :default => nil
      t.string :icon,                              :null => true, :default => nil

      t.timestamps
    end
  end
end
