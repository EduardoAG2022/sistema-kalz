puts "Creando usuario admin..."
User.find_or_create_by!(email: "admin@kalz.com") do |u|
  u.password = "kalz1234"
  u.password_confirmation = "kalz1234"
end

puts "Creando productos..."
products = [
  { name: "Camiseta Básica Blanca", description: "Algodón 100%, talla S-XL", purchase_price: 8.50, sale_price: 25.00, stock: 50, min_stock: 10 },
  { name: "Camiseta Básica Negra", description: "Algodón 100%, talla S-XL", purchase_price: 8.50, sale_price: 25.00, stock: 3, min_stock: 10 },
  { name: "Hoodie Premium Gris", description: "Fleece 350g, unisex", purchase_price: 22.00, sale_price: 65.00, stock: 20, min_stock: 5 },
  { name: "Gorra Bordada Kalz", description: "Snapback, talla única", purchase_price: 6.00, sale_price: 22.00, stock: 35, min_stock: 8 },
  { name: "Tote Bag Canvas", description: "Canvas resistente, 10L", purchase_price: 4.50, sale_price: 18.00, stock: 0, min_stock: 5 },
  { name: "Sudadera Zip Negra", description: "Zipper frontal, bolsillo canguro", purchase_price: 25.00, sale_price: 75.00, stock: 15, min_stock: 5 },
]

products.each { |attrs| Product.find_or_create_by!(name: attrs[:name]) { |p| p.assign_attributes(attrs) } }

puts "Creando clientes..."
customers = [
  { name: "María García", email: "maria@email.com", phone: "+1 555 0101", address: "Calle 5 #12, Miami, FL" },
  { name: "Carlos López", email: "carlos@email.com", phone: "+1 555 0202", address: "Av. Principal 88, Orlando, FL" },
  { name: "Ana Martínez", email: "ana@email.com", phone: "+1 555 0303", address: "Calle 10 #44, Tampa, FL" },
  { name: "Pedro Sánchez", email: "pedro@email.com", phone: "+1 555 0404", address: "Blvd Sunset 200, Miami, FL" },
]

customers.each { |attrs| Customer.find_or_create_by!(email: attrs[:email]) { |c| c.assign_attributes(attrs) } }

puts "Creando pedidos de ejemplo..."
p1 = Product.find_by(name: "Camiseta Básica Blanca")
p2 = Product.find_by(name: "Hoodie Premium Gris")
p3 = Product.find_by(name: "Gorra Bordada Kalz")
c1 = Customer.find_by(email: "maria@email.com")
c2 = Customer.find_by(email: "carlos@email.com")
c3 = Customer.find_by(email: "ana@email.com")

[
  { customer: c1, status: :completed, items: [[p1, 2], [p3, 1]], days_ago: 25 },
  { customer: c2, status: :completed, items: [[p2, 1], [p1, 1]], days_ago: 18 },
  { customer: c1, status: :completed, items: [[p2, 2]], days_ago: 14 },
  { customer: c3, status: :completed, items: [[p1, 3], [p3, 2]], days_ago: 10 },
  { customer: c2, status: :completed, items: [[p2, 1], [p3, 1]], days_ago: 7 },
  { customer: c3, status: :completed, items: [[p1, 1]], days_ago: 5 },
  { customer: c1, status: :completed, items: [[p2, 1], [p1, 2], [p3, 1]], days_ago: 3 },
  { customer: c2, status: :pending, items: [[p1, 2]], days_ago: 1 },
].each do |data|
  order = Order.create!(customer: data[:customer], status: data[:status])
  data[:items].each do |product, qty|
    order.order_items.create!(product: product, quantity: qty, unit_price: product.sale_price)
  end
  order.recalculate_total!
  order.update_column(:created_at, data[:days_ago].days.ago)
end

puts "✓ Seeds completados!"
puts "  Email: admin@kalz.com"
puts "  Contraseña: kalz1234"
