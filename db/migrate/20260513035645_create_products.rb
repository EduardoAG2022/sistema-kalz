class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :purchase_price, precision: 10, scale: 2
      t.decimal :sale_price, precision: 10, scale: 2
      t.integer :stock, default: 0
      t.integer :min_stock, default: 5

      t.timestamps
    end
  end
end
