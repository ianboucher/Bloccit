class Post < ActiveRecord::Base
  # 'dependant: :destroy' ensures that any dependants (i.e. comments) are
  # when the post is destroyed
  has_many :comments, dependent: :destroy
end
