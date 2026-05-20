class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[show edit update destroy mark_in_transit mark_in_stock]

  def index
    @purchases = Purchase.includes(:supplier, purchase_items: :product).order(purchased_at: :desc, created_at: :desc)
    @purchases = @purchases.where(status: params[:status]) if params[:status].present? && Purchase.statuses.key?(params[:status])

    @total_units    = @purchases.joins(:purchase_items).sum("purchase_items.quantity")
    @total_invested = @purchases.joins(:purchase_items).sum("purchase_items.quantity * purchase_items.unit_cost").to_f

    @pagy, @purchases = pagy(@purchases, items: 25)
  end

  def show
    @purchase_items = @purchase.purchase_items.includes(:product)
  end

  def new
    @purchase = Purchase.new(purchased_at: Date.today)
    @purchase.purchase_items.build
    @suppliers = Supplier.order(:name)
    @products = Product.order(:name)
  end

  def create
    @purchase = Purchase.new(purchase_params)
    if @purchase.save
      redirect_to @purchase, notice: "Orden de compra creada correctamente."
    else
      @suppliers = Supplier.order(:name)
      @products = Product.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @purchase.editable?
      redirect_to @purchase, alert: "Esta orden ya no puede editarse (está en stock)."
      return
    end
    @suppliers = Supplier.order(:name)
    @products = Product.order(:name)
  end

  def update
    unless @purchase.editable?
      redirect_to @purchase, alert: "Esta orden ya no puede editarse (está en stock)."
      return
    end
    if @purchase.update(purchase_params)
      redirect_to @purchase, notice: "Orden de compra actualizada."
    else
      @suppliers = Supplier.order(:name)
      @products = Product.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @purchase.ordered?
      redirect_to @purchase, alert: "Solo se pueden eliminar órdenes en estado 'Pedido'."
      return
    end
    @purchase.destroy
    redirect_to purchases_path, notice: "Orden de compra eliminada."
  end

  def mark_in_transit
    if @purchase.ordered?
      @purchase.in_transit!
      redirect_to @purchase, notice: "Orden marcada como 'En camino'."
    else
      redirect_to @purchase, alert: "La orden no puede cambiar a este estado."
    end
  end

  def mark_in_stock
    if @purchase.in_transit?
      ActiveRecord::Base.transaction do
        @purchase.purchase_items.includes(:product).each do |item|
          item.product.increment!(:stock, item.quantity)
          item.product.update!(sale_price: item.sale_price) if item.sale_price.to_f > 0
        end
        @purchase.in_stock!
      end
      redirect_to @purchase, notice: "Recepcion confirmada. Stock actualizado para #{@purchase.purchase_items.count} producto(s)."
    else
      redirect_to @purchase, alert: "La orden no puede confirmarse en este estado."
    end
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def purchase_params
    params.require(:purchase).permit(
      :name, :supplier_id, :purchased_at, :notes,
      purchase_items_attributes: [:id, :product_id, :quantity, :unit_cost, :sale_price, :_destroy]
    )
  end
end
