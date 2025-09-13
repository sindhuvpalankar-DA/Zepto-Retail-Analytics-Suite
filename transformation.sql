-- Insert categories
INSERT INTO categories (category_name)
SELECT DISTINCT category_name FROM zepto;

-- Insert products
INSERT INTO products (name, weightInGms, quantity)
SELECT DISTINCT name, weightInGms, quantity FROM zepto;

-- Insert inventory
INSERT INTO inventory (
  product_id, category_id, mrp, discountPercent,
  discountedSellingPrice, availableQuantity, outOfStock, actual_discount
)
SELECT
  p.product_id,
  c.category_id,
  z.mrp,
  z.discountPercent,
  z.discountedSellingPrice,
  z.availableQuantity,
  z.outOfStock,
  z.actual_discount
FROM zepto z
JOIN products p ON z.name = p.name
JOIN categories c ON z.category_name = c.category_name;

SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM inventory;
