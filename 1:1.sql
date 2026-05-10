--1.Create a citizens table with columns: citizen_id (PK AUTOINCREMENT), full_name TEXT NOT NULL, city TEXT.--

DROP TABLE IF EXISTS citizens;
CREATE TABLE citizens (
    citizen_id INTEGER PRIMARY KEY  AUTOINCREMENT,
	full_name TEXT NOT NULL,
	city   TEXT
);

--2.Create an id_cards table with citizen_id as both PK and FK referencing citizens(citizen_id) with ON DELETE CASCADE. Also add card_number TEXT UNIQUE NOT NULL and expires TEXT.--

CREATE TABLE id_cards(
       citizen_id INTEGER PRIMARY KEY,
	   card_number TEXT UNIQUE NOT NULL,
	   expires TEXT,
	   FOREIGN KEY (citizen_id) REFERENCES citizens (citizen_id) ON DELETE CASCADE
);

--3.Insert 3 citizens: Sophia Martinez (Barcelona), James Chen (Toronto), Amira Hassan (Cairo).--

INSERT INTO citizens (full_name,city) VALUES
('Sophia Martinez' , 'Barcelona'),
('James Chen' ,'Toronto'),
('Amira Hassan', 'Cairo');

--4.Insert 2 cards: Sophia (ID-2024-5521, expires: 2032-12-15) and James (ID-2023-7744, expires: 2031-08-22). Leave Amira without a card.--

INSERT INTO id_cards (citizen_id,card_number,expires) VALUES
(1,'ID-2024-5521', '2032-12-15'),
(2,'ID-2023-7744', '2031-08-22');

--5.Write an INNER JOIN query to list citizens with their card number.--

SELECT
  c.citizen_id,
  c.full_name,
  c.city,
  i.card_number,
  i.expires
FROM citizens c
INNER JOIN id_cards i ON i.citizen_id = c.citizen_id;

--6.Write a LEFT JOIN query to show ALL citizens — displaying 'No card' for those without one.--

SELECT
   c.citizen_id,
   c.full_name,
   c.city,
   COALESCE (i.card_number,'no card') AS card_number,
   i.expires
FROM citizens c
LEFT JOIN id_cards i ON i.citizen_id = c.citizen_id ; 

--7.Try inserting a second id card for citizen id 1. What error do you get and why?--

INSERT INTO id_cards (citizen_id,card_number,expires) VALUES
(1,'ID-2026-9999', '2035-01-01');
-- You get an error because citizen_id is the PRIMARY KEY in the id_cards table.
-- That means each citizen_id must be UNIQUE and can appear only once in the table.--

--8.Delete a citizen (who has an id card). Then query the id_cards table. What happened to their card? Why?--

DELETE FROM citizens
WHERE citizen_id = 1;

SELECT * FROM id_cards;
--The ID card row for that citizen is also automatically DELETED.
--So the id_cards TABLE will no longer contain the row with citizen_id=1--
