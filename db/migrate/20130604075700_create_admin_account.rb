# coding:utf-8

class CreateAdminAccount < ActiveRecord::Migration
  def self.up
    # pridani admina pri migraci po vytvoreni roli a jeho ulozeni
    @user = User.new(
      :username => ROOT_ACCOUNT_USERNAME,
      :email => ROOT_ACCOUNT_EMAIL,
      :password => ROOT_ACCOUNT_PASSWORD,
      :password_confirmation => ROOT_ACCOUNT_PASSWORD,
      :role => ROOT_ACCOUNT_ROLE)
    @user.save
    @user.activate!
  end

  def self.down
    User.delete_all
  end
end
