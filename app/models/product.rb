class Product < ApplicationRecord
  has_one_attached :photo
  has_many :order_items, dependent: :destroy
  has_many :purchase_items, dependent: :destroy

  validates :name, presence: true
  validates :purchase_price, :sale_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :min_stock, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :set_defaults

  def margin
    return 0 if purchase_price.zero?
    ((sale_price - purchase_price) / purchase_price * 100).round(2)
  end

  def profit_per_unit
    sale_price - purchase_price
  end

  def low_stock?
    stock <= min_stock
  end

  def out_of_stock?
    stock <= 0
  end

  def stock_status
    if out_of_stock?
      :out
    elsif low_stock?
      :low
    else
      :ok
    end
  end

  private

  def set_defaults
    self.stock ||= 0
    self.min_stock ||= 5
  end
end
