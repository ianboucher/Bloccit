class AddTopicToPosts < ActiveRecord::Migration
  def change
    # In this case, the name given to the migration is important. The name
    # instructed the rails generator to 'add' 'topic' id column to the posts
    # table.
    add_column :posts, :topic_id, :integer
    # We specified an index on topic_id with the generator. Foreign key columns
    # should always be indexed.
    add_index :posts, :topic_id
  end
end
