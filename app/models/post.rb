class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  # 'dependant: :destroy' ensures that any dependants (i.e. comments) are
  # when the post is destroyed
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  # define relationship to Labeling using the labelable interface
  has_many :labelings, as: :labelable
  # define relationship to Label through the labelable interface
  has_many :labels, through: :labelings

  # Rails provides default_scope/named_scope declarations which allow us to
  # create methods that use ActiveRecord queries to retrieve records from the
  # database. In this case the order in which the records are retrived is modified
  default_scope { order('rank DESC') }
  scope :ordered_by_title, -> { order(:title)}
  scope :ordered_by_reverse_created_at, -> { order('created_at')}

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  after_create :create_vote

  # Note that votes in the code below is an implied self.votes
  def up_votes
    votes.where(value: 1).count
  end

  def down_votes
    votes.where(value: -1).count
  end

  def points
    votes.sum(:value)
  end

  def update_rank
    age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
    new_rank = points + age_in_days
    update_attribute(:rank, new_rank)
  end

  private

  def create_vote
    user.votes.create(value: 1, post: self)
  end
end
