class AddCommentsCountToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :comments_count, :integer, default: 0
    Post.find_each { |post| Post.reset_counters(post.id, :comments) }
  end

  def down
    remove_column :posts, :comments_count
  end
end
