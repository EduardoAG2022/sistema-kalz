class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :status, default: 0
      t.text :notes
      t.decimal :total, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
