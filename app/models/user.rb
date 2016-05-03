class User < ActiveRecord::Base

  # we register an inline callback directly after the before_save callback. The
  # callback { self.email = email.downcase } is triggered by the first callback.

  before_save { self.email = email.downcase }
  before_save { self.name = name.split(/(?=[A-Z])|(\s)/).map(&:capitalize).join unless name.nil? }

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

end
