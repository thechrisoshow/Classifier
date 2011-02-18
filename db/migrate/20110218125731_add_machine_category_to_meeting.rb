class AddMachineCategoryToMeeting < ActiveRecord::Migration
  def self.up
    add_column :messages, :machine_category_id, :integer
  end

  def self.down
    remove_column :messages, :machine_category_id
  end
end
