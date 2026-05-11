--1.Create orders: id PK AUTOINCREMENT, order_no TEXT UNIQUE, address TEXT NOT NULL, phone TEXT NOT NULL, ordered_at TEXT DEFAULT (date('now'))--

CREATE TABLE orders(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
	   order_no TEXT UNIQUE,
	   address TEXT NOT NULL,
	   phone TEXT NOT NULL,
	   ordered_at TEXT DEFAULT(date('now'))
);

--2.Create products: id PK AUTOINCREMENT, name TEXT NOT NULL, unit_price REAL NOT NULL CHECK (unit_price >= 0).--

CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
	  name TEXT NOT NULL,
	  unit_price REAL NOT NULL CHECK (unit_price >=0)
);

--3.Create sales (junction): order_id FK, product_id FK, qty INTEGER NOT NULL DEFAULT 1 CHECK (qty > 0), with composite PK (order_id, product_id) (Each row means one product sold in one order).--

CREATE TABLE sales (
       order_id INTEGER NOT NULL,
	   product_id INTEGER NOT NULL,
	   qty INTEGER NOT NULL DEFAULT 1 CHECK (qty>0),
	   PRIMARY KEY (order_id, product_id),
	   FOREIGN KEY (order_id) REFERENCES orders(id),
	   FOREIGN KEY (product_id) REFERENCES products(id)
);

--4.Insert sample data--

INSERT INTO orders (id, order_no, address, phone, ordered_at)
VALUES
          (1, 'ORD-1001', '12 Lake St, Boston',  '+1-555-0101', '2026-01-05'),
          (2, 'ORD-1002', '12 Lake St, Boston',  '+1-555-0101', '2026-01-07'),
          (3, 'ORD-1003', '88 Pine Ave, Seattle', '+1-555-0202', '2026-01-09'),
          (4, 'ORD-1004', '44 Nile Rd, Cairo',    '+1-555-0303', '2026-01-10'),
          (5, 'ORD-1005', '77 Hill Rd, Austin',   '+1-555-0404', '2026-01-11'); -- no sales rows

INSERT INTO products (id, name, unit_price)
VALUES
  (1, 'Laptop', 1200),
  (2, 'Mouse', 25),
  (3, 'Keyboard', 80),
  (4, 'Webcam', 95),
  (5, 'Monitor', 280),
  (6, 'Desk Lamp', 35),
  (7, 'USB Hub', 40);

INSERT INTO sales (order_id, product_id, qty)
VALUES
  (1, 1, 1),
  (1, 2, 2),
  (1, 3, 1),
  (2, 4, 1),
  (2, 7, 2),
  (3, 5, 1),
  (3, 6, 3),
  (4, 2, 1),
  (4, 7, 1);

--5.Write a query to show each sold product with order_no, address, phone, product_name, qty, unit_price, and line total (qty * unit_price)--

SELECT
    o.order_no,
	o.address,
	o.phone,
	p.name AS product_name,
	s.qty,
	p.unit_price,
	(s.qty*p.unit_price) AS line_total
FROM sales s 
JOIN orders o ON o.id= s.order_id
JOIN products p ON p.id= s.product_id;

--6.Write a query to list each order with total item count (SUM(qty)) and total price (SUM(qty * unit_price))--

SELECT 
    o.id,
	o.order_no,
	SUM(s.qty) AS total_items,
	SUM(s.qty*p.unit_price) AS total_price
FROM orders o 
JOIN sales s ON s.order_id=o.id
JOIN products p ON p.id=s.product_id
GROUP BY o.id, o.order_no;

--7.Write a query to list each order with all product names. Make sure to print all products of the same order before going to the next order--

SELECT
    o.order_no,
	p.name AS product_name
FROM orders o
JOIN sales s ON s.order_id=o.id
JOIN products p ON p.id = s.product_id
ORDER BY o.id, p.name;

--8.Write a query to calculate each phone (or address) and the sum of all orders

SELECT
   o.phone,
   o.address,
   SUM(s.qty*p.unit_price) AS total_spent
FROM orders o 
JOIN sales s ON s.order_id=o.id
JOIN products p ON p.id = s.product_id
GROUP BY o.phone, o.address; 

--9.Write a query to show orders that have no products in sales

SELECT
    o.id,
	  o.order_no,
	  o.address,
	  o.phone,
	  o.ordered_at
FROM orders o 
LEFT JOIN sales s ON s.order_id = o.id
WHERE s.order_id IS NULL;
