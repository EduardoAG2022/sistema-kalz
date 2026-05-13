class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  enum :status, { pending: 0, completed: 1, cancelled: 2 }, default: :pending

  validates :customer, presence: true

  after_save :recalculate_total!

  def recalculate_total!
    calculated = order_items.reload.sum { |item| item.quantity.to_i * item.unit_price.to_f }
    update_column(:total, calculated) if total.to_f != calculated
  end
end
