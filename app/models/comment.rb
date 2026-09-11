class Comment < ApplicationRecord
  belongs_to :project

  before_create :generate_author_token

  validates :body, presence: true, length: { maximum: 2000 }
  validates :author_name, length: { maximum: 50 }, allow_blank: true

  def display_name
    author_name.presence || "Anonymous"
  end

  private

  def generate_author_token
    self.author_token = SecureRandom.hex(16)
  end
end
