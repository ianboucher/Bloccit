class AddCommentsCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :comments_count, :integer, default: 0
    User.find_each { |user| User.reset_counters(user.id, :comments) }
  end

  def down
    remove_column :users, :comments_count
  end
end
