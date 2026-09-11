class BannedIp < ApplicationRecord
  validates :ip_address, presence: true, uniqueness: true

  def self.banned?(ip_address)
    exists?(ip_address: ip_address)
  end
end
