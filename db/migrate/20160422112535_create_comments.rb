class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      # Here, 'index' tells the db to index the post_id column so that it can be
      # searched efficiently. This is added automatically when the model is generated
      # with the 'references' argument.
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :comments, :posts
  end
end
