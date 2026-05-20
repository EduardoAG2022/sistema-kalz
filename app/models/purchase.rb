class Purchase < ApplicationRecord
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :purchased_at, presence: true

  after_create :increment_stock

  def total_cost
    quantity * unit_cost
  end

  private

  def increment_stock
    product.increment!(:stock, quantity)
  end
end
