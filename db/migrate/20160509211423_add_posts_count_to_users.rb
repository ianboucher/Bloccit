class AddPostsCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :posts_count, :integer, default: 0
    User.find_each { |user| User.reset_counters(user.id, :posts) }
  end

  def down
    remove_column :users, :posts_count, :integer, default: 0
  end
end
