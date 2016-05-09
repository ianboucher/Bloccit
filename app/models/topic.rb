class Topic < ActiveRecord::Base

  has_many :posts, dependent: :destroy
  has_many :sponsored_posts, dependent: :destroy
  # define relationship to Labeling using the labelable interface
  has_many :labelings, as: :labelable
  # define relationship to Label through the labelable interface
  has_many :labels, through: :labelings

  validates :name, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 15 }, presence: true
  validates :public, :inclusion => { :in => [true, false] }

  scope :publicly_viewable, -> { where(public: true) }
  scope :privately_viewable, -> { where(public: false) }
  scope :visible_to, -> (user){ user ? all : publicly_viewable }

end
