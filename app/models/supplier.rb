class Supplier < ApplicationRecord
  has_many :purchases, dependent: :nullify

  validates :name, presence: true

  def purchases_count
    purchases.count
  end
end
