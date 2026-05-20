class Purchase < ApplicationRecord
  belongs_to :supplier, optional: true
  has_many :purchase_items, dependent: :destroy
  accepts_nested_attributes_for :purchase_items, allow_destroy: true, reject_if: :all_blank

  enum status: { ordered: 0, in_transit: 1, in_stock: 2 }

  validates :name, presence: true
  validates :purchased_at, presence: true

  def total_units
    purchase_items.sum(:quantity)
  end

  def total_invested
    purchase_items.sum("quantity * unit_cost").to_f.round(2)
  end

  def total_revenue
    purchase_items.sum("quantity * sale_price").to_f.round(2)
  end

  def margin
    invested = total_invested
    return 0 if invested.zero?
    ((total_revenue - invested) / invested * 100).round(2)
  end

  def editable?
    ordered? || in_transit?
  end
end
