class AddDisabledFieldToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :disabled, :boolean, :default => false
  end

  def self.down
    remove_column :feeds, :disabled
  end
end
