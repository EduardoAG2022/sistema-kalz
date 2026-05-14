class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @customers = Customer.includes(:orders).order(:name)
    @customers = @customers.where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    @pagy, @customers = pagy(@customers, items: 20)
  end

  def show
    @orders = @customer.orders.includes(:order_items).order(created_at: :desc)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: "Cliente creado correctamente." }
        format.json { render json: { id: @customer.id, name: @customer.name } }
      else
        existing = find_duplicate_customer
        format.html { render :new, status: :unprocessable_entity }
        format.json {
          render json: {
            errors: @customer.errors.full_messages,
            existing: existing ? { id: existing.id, name: existing.name } : nil
          }, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: "Cliente actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "Cliente eliminado."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def find_duplicate_customer
    p = customer_params
    return nil unless p[:email].present? || p[:phone].present?
    conditions = []
    conditions << Customer.where("LOWER(email) = ?", p[:email].downcase) if p[:email].present?
    conditions << Customer.where(phone: p[:phone]) if p[:phone].present?
    conditions.reduce(:or).first
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :address)
  end
end
