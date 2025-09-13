-- Out-of-stock products
SELECT * FROM inventory WHERE outOfStock = TRUE;
SELECT * FROM inventory WHERE outOfStock = FALSE;


-- High-revenue products
SELECT DISTINCT p.name, p.quantity,i.discountedSellingPrice * i.availableQuantity AS estimated_revenue  -- REVENUE CALCULATION FORMULA : ( REVENUE = NUM OF UNITS SOLD * SELLING PRICE PER UNIT )
FROM inventory i
JOIN products p ON i.product_id = p.product_id
ORDER BY estimated_revenue DESC
LIMIT 10;

-- Dead stock detection
SELECT p.name, i.availableQuantity, i.actual_discount
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.availableQuantity > 100 AND i.actual_discount < 10;

-- Category performance
SELECT c.category_name,
       COUNT(*) AS product_count,
       AVG(i.mrp) AS avg_mrp,
       AVG(i.discountedSellingPrice) AS avg_price,
       AVG(i.actual_discount) AS avg_discount,
       SUM(i.availableQuantity) AS total_stock
FROM inventory i
JOIN categories c ON i.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_stock DESC;
