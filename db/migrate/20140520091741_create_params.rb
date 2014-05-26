class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :param_name,     :null => false
      t.text :param_value,      :null => true

      t.timestamps
    end
    
    Params.new(
      :param_name => "season",
      :param_value => {
        :value => 0
      }
    ).save
    Params.new(
      :param_name => "season_day",
      :param_value => {
        :value => 0
      }
    ).save
  end
end
