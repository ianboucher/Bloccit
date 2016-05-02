class Post < ActiveRecord::Base
  belongs_to :topic
  # 'dependant: :destroy' ensures that any dependants (i.e. comments) are
  # when the post is destroyed
  has_many :comments, dependent: :destroy

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true

end
