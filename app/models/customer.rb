class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false, message: "ya está registrado en otro cliente" }, allow_blank: true
  validates :phone, uniqueness: { message: "ya está registrado en otro cliente" }, allow_blank: true

  def total_spent
    orders.completed.sum(:total)
  end

  def orders_count
    orders.completed.count
  end
end
