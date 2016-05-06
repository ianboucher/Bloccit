class Topic < ActiveRecord::Base
  
  has_many :posts, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :sponsored_posts, dependent: :destroy
  # define relationship to Labeling using the labelable interface
  has_many :labelings, as: :labelable
  # define relationship to Label through the labelable interface
  has_many :labels, through: :labelings

  validates :name, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 15 }, presence: true
  validates :public, presence: true

end
