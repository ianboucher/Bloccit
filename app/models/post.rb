class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  # 'dependant: :destroy' ensures that any dependants (i.e. comments) are
  # when the post is destroyed
  has_many :comments, dependent: :destroy
  # define relationship to Labeling using the labelable interface
  has_many :labelings, as: :labelable
  # define relationship to Label through the labelable interface
  has_many :labels, through: :labelings

  # Rails provides default_scope/named_scope declarations which allow us to
  # create methods that use ActiveRecord queries to retrieve records from the
  # database. In this case the order in which the records are retrived is modified
  default_scope { order('created_at DESC') }
  scope :ordered_by_title, -> { order(:title)}
  scope :ordered_by_reverse_created_at, -> { order('created_at')}

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

end
