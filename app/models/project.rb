class Project < ApplicationRecord
  has_many :comments, dependent: :destroy

  before_validation :generate_slug, if: -> { slug.blank? }
  validates :slug, uniqueness: true

  def to_param
    slug
  end

  private

  def generate_slug
    base = category.presence || title.presence || "project"
    candidate = base.parameterize
    n = 1
    while Project.where.not(id: id).exists?(slug: candidate)
      n += 1
      candidate = "#{base.parameterize}-#{n}"
    end
    self.slug = candidate
  end
end
