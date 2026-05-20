class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[show edit update destroy]

  def index
    @suppliers = Supplier.order(:name)
    @suppliers = @suppliers.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @pagy, @suppliers = pagy(@suppliers, items: 20)
  end

  def show
    @purchases = @supplier.purchases.includes(:purchase_items).order(purchased_at: :desc, created_at: :desc)
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      redirect_to suppliers_path, notice: "Proveedor creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: "Proveedor actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @supplier.destroy
    redirect_to suppliers_path, notice: "Proveedor eliminado."
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :contact_name, :email, :phone, :notes)
  end
end
