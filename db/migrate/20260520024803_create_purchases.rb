class CreatePurchases < ActiveRecord::Migration[7.2]
  def change
    create_table :purchases do |t|
      t.references :product, null: false, foreign_key: true
      t.string :supplier
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_cost, precision: 10, scale: 2, null: false, default: 0
      t.date :purchased_at
      t.text :notes

      t.timestamps
    end
  end
end
