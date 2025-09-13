
CREATE TABLE zepto (
  category_name TEXT,
  name TEXT,
  mrp NUMERIC,
  discountPercent NUMERIC,
  quantity TEXT,
  discountedSellingPrice NUMERIC,
  availableQuantity INTEGER,
  outOfStock BOOLEAN,
  weightInGms INTEGER
);

SELECT * FROM zepto;
 
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  category_name TEXT UNIQUE NOT NULL
);

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  weightInGms INTEGER,
  quantity TEXT
);

CREATE TABLE inventory (
  inventory_id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(product_id),
  category_id INTEGER REFERENCES categories(category_id),
  mrp NUMERIC,
  discountPercent NUMERIC,
  discountedSellingPrice NUMERIC,
  availableQuantity INTEGER,
  outOfStock BOOLEAN,
  actual_discount NUMERIC
);