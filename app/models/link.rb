class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :validate_url_format

  private

  def validate_url_format
    unless url =~ URI::DEFAULT_PARSER.make_regexp(%w[http https])
      errors.add(:url, "#{url} is not a valid URL")
    end
  end
end
