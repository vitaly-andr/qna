class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github google_oauth2 vkontakte yandex]
  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :rewards, dependent: :nullify
  validates :name, presence: true

  def self.from_omniauth(auth, emails)
    email = emails.first&.downcase.strip || auth.info.email&.downcase.strip

    Rails.logger.debug "Searching for user with email: #{email}"
    user = User.find_by(email: email)

    if user
      unless user.update(provider: auth.provider, uid: auth.uid)
        Rails.logger.error "Failed to update user: #{user.errors.full_messages.join(', ')}"
      end
    else
      user = User.new(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email || emails.first,
        name: auth.info.name || auth.info.nickname,
        password: Devise.friendly_token[0, 20]
      )

      unless user.save
        Rails.logger.error "Failed to create user: #{user.errors.full_messages.join(', ')}"
      end
    end

    user
  end

  def author_of?(resource)
    resource.author_id == id
  end
end
