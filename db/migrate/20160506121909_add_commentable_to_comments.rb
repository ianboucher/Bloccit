class AddCommentableToComments < ActiveRecord::Migration
  def up
    remove_column :comments, :post_id
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string

    add_index :comments, [:commentable_id, :commentable_type]
  end

  def down
    remove_column :comments, :commentable_id
    remove_column :comments, :commentable_type

    add_column :comments, :post_id, :integer
    add_index :comments, :post_id
  end
end
