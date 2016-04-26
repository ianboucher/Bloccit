class Post < ActiveRecord::Base
  belongs_to :topic
  # 'dependant: :destroy' ensures that any dependants (i.e. comments) are
  # when the post is destroyed
  has_many :comments, dependent: :destroy
end
