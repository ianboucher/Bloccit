class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
      add_foreign_key :answers, :quesions
  end
end
