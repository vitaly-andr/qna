class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github google_oauth2 vkontakte]
  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :rewards, dependent: :nullify
  validates :name, presence: true

  def self.from_omniauth(auth, emails)
    user = User.find_by(email: emails) || User.find_by(email: auth.info.email)

    if user
      user.update(provider: auth.provider, uid: auth.uid)
    else
      user = User.create(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email || emails.first,
        name: auth.info.name || auth.info.nickname,
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end

  def author_of?(resource)
    resource.author_id == id
  end
end
