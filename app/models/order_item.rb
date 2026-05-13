class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_unit_price

  def subtotal
    quantity * unit_price
  end

  private

  def set_unit_price
    self.unit_price ||= product&.sale_price
  end
end
