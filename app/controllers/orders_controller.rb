class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy complete cancel]

  def index
    @orders = Order.includes(:customer).order(created_at: :desc)
    @orders = @orders.where(status: params[:status]) if params[:status].present?
    @pagy, @orders = pagy(@orders, items: 20)
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def new
    @order = Order.new
    @order.order_items.build
    @customers = Customer.order(:name)
    @products = Product.order(:name)
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, notice: "Pedido creado correctamente."
    else
      @customers = Customer.order(:name)
      @products = Product.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @customers = Customer.order(:name)
    @products = Product.order(:name)
  end

  def update
    if @order.update(order_params)
      @order.recalculate_total!
      redirect_to @order, notice: "Pedido actualizado correctamente."
    else
      @customers = Customer.order(:name)
      @products = Product.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: "Pedido eliminado."
  end

  def complete
    if @order.update(status: :completed)
      @order.order_items.each do |item|
        item.product.decrement!(:stock, item.quantity)
      end
      redirect_to @order, notice: "Pedido marcado como completado. Stock actualizado."
    else
      redirect_to @order, alert: "No se pudo completar el pedido."
    end
  end

  def cancel
    @order.update(status: :cancelled)
    redirect_to @order, notice: "Pedido cancelado."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_id, :notes, order_items_attributes: [:id, :product_id, :quantity, :unit_price, :_destroy])
  end
end
