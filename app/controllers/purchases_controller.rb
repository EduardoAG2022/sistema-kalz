class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[show destroy]

  def index
    @purchases = Purchase.includes(:product).order(purchased_at: :desc, created_at: :desc)
    @purchases = @purchases.where(product_id: params[:product_id]) if params[:product_id].present?

    @total_units   = @purchases.sum(:quantity)
    @total_invested = @purchases.sum("quantity * unit_cost")

    @pagy, @purchases = pagy(@purchases, items: 25)
    @products = Product.order(:name)
  end

  def show
  end

  def new
    @purchase = Purchase.new(purchased_at: Date.today, product_id: params[:product_id])
    @products = Product.order(:name)
  end

  def create
    @purchase = Purchase.new(purchase_params)
    if @purchase.save
      redirect_to purchases_path, notice: "Compra registrada. Stock actualizado (+#{@purchase.quantity} uds.)."
    else
      @products = Product.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    qty = @purchase.quantity
    product = @purchase.product
    @purchase.destroy
    product.decrement!(:stock, qty)
    redirect_to purchases_path, notice: "Compra eliminada. Stock ajustado (-#{qty} uds.)."
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def purchase_params
    params.require(:purchase).permit(:product_id, :supplier, :quantity, :unit_cost, :purchased_at, :notes)
  end
end
