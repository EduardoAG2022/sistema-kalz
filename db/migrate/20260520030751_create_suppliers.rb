class CreateSuppliers < ActiveRecord::Migration[7.2]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :contact_name
      t.string :email
      t.string :phone
      t.text :notes

      t.timestamps
    end
  end
end
