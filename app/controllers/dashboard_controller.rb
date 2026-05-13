class DashboardController < ApplicationController
  def index
    @period = params[:period] || "month"

    @total_revenue = Order.completed.sum(:total)
    @orders_count = Order.completed.count
    @products_count = Product.count
    @customers_count = Customer.count

    @top_product = OrderItem
      .joins(:product, :order)
      .where(orders: { status: :completed })
      .group("products.name")
      .order("SUM(order_items.quantity) DESC")
      .limit(1)
      .sum("order_items.quantity")
      .first

    @low_stock_products = Product.where("stock <= min_stock").order(:stock).limit(5)
    @recent_orders = Order.includes(:customer).order(created_at: :desc).limit(5)

    @sales_chart_data = build_sales_chart_data(@period)
    @top_products_data = build_top_products_data
  end

  private

  def build_sales_chart_data(period)
    orders = Order.completed
    case period
    when "day"
      orders.group_by_hour(:created_at, last: 24, format: "%H:%M").sum(:total)
    when "week"
      orders.group_by_day(:created_at, last: 7, format: "%d %b").sum(:total)
    when "year"
      orders.group_by_month(:created_at, last: 12, format: "%b %Y").sum(:total)
    else
      orders.group_by_day(:created_at, last: 30, format: "%d %b").sum(:total)
    end
  end

  def build_top_products_data
    OrderItem
      .joins(:product, :order)
      .where(orders: { status: :completed })
      .group("products.name")
      .order("SUM(order_items.quantity) DESC")
      .limit(5)
      .sum("order_items.quantity")
  end
end
