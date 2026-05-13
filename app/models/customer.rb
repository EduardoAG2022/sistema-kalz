class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy

  validates :name, presence: true

  def total_spent
    orders.completed.sum(:total)
  end

  def orders_count
    orders.completed.count
  end
end
