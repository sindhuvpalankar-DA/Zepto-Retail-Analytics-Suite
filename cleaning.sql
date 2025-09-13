-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100,
    discountedSellingPrice = discountedSellingPrice / 100;

-- Remove invalid entries
DELETE FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0 OR name IS NULL;

-- Add actual discount column
ALTER TABLE zepto ADD COLUMN actual_discount NUMERIC;

-- Calculate actual discount
UPDATE zepto
SET actual_discount = ROUND(((mrp - discountedSellingPrice) * 100.0 / mrp), 2);
