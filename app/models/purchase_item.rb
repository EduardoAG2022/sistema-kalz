class PurchaseItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def subtotal_cost
    (quantity.to_i * unit_cost.to_f).round(2)
  end

  def subtotal_revenue
    (quantity.to_i * sale_price.to_f).round(2)
  end
end
