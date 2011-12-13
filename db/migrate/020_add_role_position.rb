class AddRolePosition < ActiveRecord::Migration
  def self.up
    add_column :roles, :position, :integer, :default => 1
    add_column :roles, :builtin, :integer, :default => 0, :null => false
    Role.all.each_with_index {|role, i| role.update_attribute(:position, i+1)}
    remove_column :roles, :builtin
  end

  def self.down
    remove_column :roles, :position
  end
end
