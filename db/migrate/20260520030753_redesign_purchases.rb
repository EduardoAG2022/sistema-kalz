class RedesignPurchases < ActiveRecord::Migration[7.2]
  def up
    # Remove old columns
    remove_foreign_key :purchases, :products if foreign_key_exists?(:purchases, :products)
    remove_column :purchases, :product_id
    remove_column :purchases, :supplier
    remove_column :purchases, :quantity
    remove_column :purchases, :unit_cost

    # Add new columns
    add_column :purchases, :name, :string
    add_column :purchases, :supplier_id, :bigint
    add_column :purchases, :status, :integer, default: 0, null: false

    add_index :purchases, :supplier_id
  end

  def down
    remove_index :purchases, :supplier_id if index_exists?(:purchases, :supplier_id)
    remove_column :purchases, :status
    remove_column :purchases, :supplier_id
    remove_column :purchases, :name

    add_column :purchases, :product_id, :bigint, null: false, default: 0
    add_column :purchases, :supplier, :string
    add_column :purchases, :quantity, :integer, null: false, default: 1
    add_column :purchases, :unit_cost, :decimal, precision: 10, scale: 2, null: false, default: 0
    add_foreign_key :purchases, :products
  end
end
