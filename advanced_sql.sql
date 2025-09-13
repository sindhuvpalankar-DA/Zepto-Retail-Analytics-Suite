-- Top 3 discounted products per category
WITH ranked_discounts AS (
  SELECT i.*, p.name, c.category_name,
         RANK() OVER (PARTITION BY c.category_name ORDER BY i.actual_discount DESC) AS rank
  FROM inventory i
  JOIN products p ON i.product_id = p.product_id
  JOIN categories c ON i.category_id = c.category_id
)
SELECT category_name, name, actual_discount
FROM ranked_discounts
WHERE rank <= 3;

-- Top 5 Products by Revenue per Category
WITH revenue_ranked AS (
  SELECT c.category_name, p.name,
         i.discountedSellingPrice * i.availableQuantity AS revenue,
         RANK() OVER (PARTITION BY c.category_name ORDER BY i.discountedSellingPrice * i.availableQuantity DESC) AS rank
  FROM inventory i
  JOIN products p ON i.product_id = p.product_id
  JOIN categories c ON i.category_id = c.category_id
)
SELECT category_name, name, revenue
FROM revenue_ranked
WHERE rank <= 5;

-- Products with High Discount but Low Stock
SELECT p.name, i.actual_discount, i.availableQuantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.actual_discount > 40 AND i.availableQuantity < 10;

-- Category Wise Average Discount vs. Average MRP
SELECT c.category_name,
       ROUND(AVG(i.actual_discount), 2) AS avg_discount,
       ROUND(AVG(i.mrp), 2) AS avg_mrp
FROM inventory i
JOIN categories c ON i.category_id = c.category_id
GROUP BY c.category_name
ORDER BY avg_discount DESC;

-- Find Duplicate Products (Same Name, Different Weight)
SELECT name, COUNT(DISTINCT weightInGms) AS weight_variants
FROM products
GROUP BY name
HAVING COUNT(DISTINCT weightInGms) > 1;

-- Total Inventory Value by Category
SELECT c.category_name,
       SUM(i.discountedSellingPrice * i.availableQuantity) AS total_value
FROM inventory i
JOIN categories c ON i.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_value DESC;

-- Dead Stock by Category (Low Discount, High Quantity)
SELECT c.category_name, p.name, i.availableQuantity, i.actual_discount
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN categories c ON i.category_id = c.category_id
WHERE i.availableQuantity > 100 AND i.actual_discount < 10
ORDER BY i.availableQuantity DESC;

-- Price Outliers Using Percentile Buckets
WITH price_stats AS (
  SELECT i.*, NTILE(4) OVER (ORDER BY i.mrp) AS price_quartile
  FROM inventory i
)
SELECT price_quartile, COUNT(*) AS product_count
FROM price_stats
GROUP BY price_quartile;

-- Most Discounted Product per Category (Using ROW_NUMBER)
WITH ranked_discounts AS (
  SELECT i.*, p.name, c.category_name,
         ROW_NUMBER() OVER (PARTITION BY c.category_name ORDER BY i.actual_discount DESC) AS rn
  FROM inventory i
  JOIN products p ON i.product_id = p.product_id
  JOIN categories c ON i.category_id = c.category_id
)
SELECT category_name, name, actual_discount
FROM ranked_discounts
WHERE rn = 1;
