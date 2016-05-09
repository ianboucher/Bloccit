class User < ActiveRecord::Base

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # we register an inline callback directly after the before_save callback. The
  # callback { self.email = email.downcase } is triggered by the first callback.
  before_save { self.email = email.downcase }
  before_save { self.name = name.split(/(?=[A-Z])|(\s)/).map(&:capitalize).join unless name.nil? }
  before_save { self.role ||= :member } # set role to member if not specified

  validates :name, length: { minimum: 1, maxiumum: 100 }, presence: true
  # 1st password validation executes if password_digest is nil - i.e. if a password
  # has not been created.
  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  # 2nd validation executes when a user's password is updated. 'allow_blank' skips
  # the validation if no updated password is given, which allows other user attributes
  # to be updated witout being forced to set the password.
  validates :password, length: { minimum: 6 }, allow_blank: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maxiumum: 254 }

  # has_secure_password adds methods to set and authenticate against a BCrypt
  # password. This mechanism requires you to have a password_digest attribute.
  has_secure_password

  # We use enum to allow values (strings) to map to integers, which allows greater
  # control over the roles that can be assigned to a user and provides access to
  # helpful methods
  enum role: [:member, :admin]

  def favorite_for(post)
    # find favorites with post_id matching post. Return either the favorite or nil.
    favorites.where(post_id: post.id).first
  end

  # def avatar_url(size)
  #   gravatar_id = Digest::MD5::hexdigest(self.email).downcase
  #   gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  # end
end
