--1.Create a categories table: id PK AUTOINCREMENT, title TEXT UNIQUE NOT NULL.--

CREATE TABLE categories (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
	   title TEXT UNIQUE NOT NULL
);

--2.Create a posts table: id PK AUTOINCREMENT, category_id FK (NOT NULL), title TEXT, views INTEGER DEFAULT 0. Use ON DELETE RESTRICT.--

CREATE TABLE posts(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
	   category_id INTEGER NOT NULL,
	   title TEXT,
	   views INTEGER DEFAULT 0,
	   FOREIGN KEY (category_id) REFERENCES categories(id)
	   ON DELETE RESTRICT
);

--3.Insert 3 categories and at least 5 posts spread across the categories.--

INSERT INTO categories (title) VALUES
('Sports'),
('Music'),
('Travel');

INSERT INTO posts(category_id,title,views) VALUES
(1,'Top football Player of the year',3200),
(1,'How Olympic Training Works',1700),
(2,'Best Pop Albums Ever Made',2400),
(2,'How Music Streaming Changed',1500),
(3,'Backpacking Through South America',4100),
(3,'Top 10 Places To Visit In Japan',3600);

--4.Query: list all posts with their category title using INNER JOIN.--

SELECT
   p.id,
   p.title,
   p.views,
   c.title AS category
FROM posts p 
INNER JOIN categories c ON c.id = p.category_id;

--5.Query: count posts per category, show categories with 0 posts too (use LEFT JOIN + GROUP BY).--

SELECT 
    c.title AS category,
	COUNT (p.id) AS post_count
FROM categories c
LEFT JOIN posts p ON p.category_id = c.id
GROUP BY c.id; 

--6.Query: find the category with the highest total views using GROUP BY + ORDER BY + LIMIT 1.--

SELECT
   c.title AS category,
   SUM(p.views) AS total_views
FROM categories c
LEFT JOIN posts p ON p.category_id = c.id
GROUP BY c.id
ORDER BY total_views DESC
LIMIT 1;
