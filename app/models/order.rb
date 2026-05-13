class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  enum :status, { pending: 0, completed: 1, cancelled: 2 }, default: :pending

  validates :customer, presence: true

  before_save :calculate_total

  def calculate_total
    self.total = order_items.sum { |item| item.quantity * item.unit_price }
  end

  def recalculate_total!
    update!(total: order_items.sum { |item| item.quantity * item.unit_price })
  end
end
