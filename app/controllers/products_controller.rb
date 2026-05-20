class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.with_attached_photo.order(:name)
    @products = @products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?

    case params[:stock_filter]
    when "in"  then @products = @products.where("stock > 0")
    when "low" then @products = @products.where("stock > 0 AND stock <= min_stock")
    when "out" then @products = @products.where("stock <= 0")
    end

    @pagy, @products = pagy(@products, items: 20)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Producto creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Producto actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Producto eliminado."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :purchase_price, :sale_price, :stock, :min_stock, :photo)
  end
end
