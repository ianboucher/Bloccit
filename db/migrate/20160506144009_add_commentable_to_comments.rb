class AddCommentableToComments < ActiveRecord::Migration
  def up
    remove_column :comments, :post_id
    remove_column :comments, :topic_id
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string

    #remove_index :comments, :post_id
    #remove_index :comments, :topic_id
    add_index :comments, [:commentable_id, :commentable_type]
  end

  def down
    add_column :comments, :post_id, :integer
    add_column :comments, :topic_id, :integer
    remove_column :comments, :commentable_id
    remove_column :comments, :commentable_type

    add_index :comments, :post_id
    add_index :comments, :topic_id
    #remove_index :comments, [:commentable_id, :commentable_type]
  end
end
