--Step 1: Create Customer Tabl

CREATE TABLE Customer (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  street_address VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  postal_code VARCHAR(15),
  country VARCHAR(50),
  registration_date DATE,
  username VARCHAR(50) UNIQUE,
  password VARCHAR(100)
);

SELECT * FROM customer;

--Step 2: Create Vendor Table

CREATE TABLE Vendor (
  vendor_id INT PRIMARY KEY,
  vendor_name VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20),
  street_address VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  postal_code VARCHAR(15),
  country VARCHAR(50)
);

--Step 3: Create Product Table

CREATE TABLE Product (
  product_id INT PRIMARY KEY,
  vendor_id INT,
  product_name VARCHAR(100),
  description VARCHAR(300),
  price DECIMAL(10,2),
  quantity_in_stock INT,
  category VARCHAR(50),
  image_url VARCHAR(255),
  FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

--Step 4: Create CustomerOrder Table

CREATE TABLE CustomerOrder (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  status VARCHAR(50),
  shipping_address VARCHAR(100),
  total_amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

--Step 5: Create OrderItem Table

CREATE TABLE OrderItem (
  item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
  FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

--Step 6: Create Cart Table

CREATE TABLE Cart (
  cart_id INT PRIMARY KEY,
  customer_id INT,
  created_at DATE,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

--Step 7: Create CartProduct Table

CREATE TABLE CartProduct (
  cart_product_id INT PRIMARY KEY,
  cart_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
  FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

--Step 8: Create Wishlist Table

CREATE TABLE Wishlist (
  wishlist_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  added_at DATE,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
  FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Step 9: Create ReturnRequest Table

CREATE TABLE ReturnRequest (
  return_id INT PRIMARY KEY,
  item_id INT,
  request_date DATE,
  reason VARCHAR(200),
  status VARCHAR(50),
  FOREIGN KEY (item_id) REFERENCES OrderItem(item_id)
);

-- 1: Insert Sample Data into Customer

INSERT INTO Customer VALUES (
  1, 'Abdirahman', 'Ali', 'abdi@example.com', '123-456-7890',
  '123 Tech Street', 'Toronto', 'Ontario', 'M1X 2A7', 'Canada',
  TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'abdi123', 'pass123'
);

INSERT INTO Customer VALUES (
  2, 'Sara', 'Jamal', 'sara@example.com', '987-654-3210',
  '456 Market Ave', 'Mississauga', 'Ontario', 'L5B 2T4', 'Canada',
  TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'saraJ', 'sara456'
);

INSERT INTO Customer VALUES (
  3, 'Jason', 'Lee', 'jason@example.com', '416-123-4321',
  '789 Bay Street', 'Toronto', 'Ontario', 'M5G 2C8', 'Canada',
  TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'jlee', 'pass789'
);

INSERT INTO Customer VALUES (
  4, 'Emily', 'Chen', 'emily@example.com', '416-234-5678',
  '321 Queen St', 'Toronto', 'Ontario', 'M5V 1Z4', 'Canada',
  TO_DATE('2024-07-22', 'YYYY-MM-DD'), 'emchen', 'empass'
);

INSERT INTO Customer VALUES (
  5, 'Mohammed', 'Khan', 'mkhan@example.com', '416-345-9876',
  '456 Dundas St', 'Mississauga', 'Ontario', 'L5A 1W2', 'Canada',
  TO_DATE('2024-06-18', 'YYYY-MM-DD'), 'mkhan', 'mksecure'
);

INSERT INTO Customer VALUES (
  6, 'Aisha', 'Rahman', 'aisha@example.com', '416-456-1234',
  '987 Elm St', 'Markham', 'Ontario', 'L6B 1C9', 'Canada',
  TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'aishaR', 'aishapw'
);

INSERT INTO Customer VALUES (
  7, 'Daniel', 'Nguyen', 'dnguyen@example.com', '416-567-2345',
  '654 Sunset Blvd', 'Richmond Hill', 'Ontario', 'L4C 0C9', 'Canada',
  TO_DATE('2024-08-12', 'YYYY-MM-DD'), 'danielN', 'nguyen123'
);

INSERT INTO Customer VALUES (
  8, 'Natalie', 'Singh', 'natalie@example.com', '416-678-3456',
  '222 Green Ln', 'Pickering', 'Ontario', 'L1V 2P9', 'Canada',
  TO_DATE('2024-06-26', 'YYYY-MM-DD'), 'natsingh', 'singhpass'
);

INSERT INTO Customer VALUES (
  9, 'Omar', 'Hassan', 'omar@example.com', '416-789-4567',
  '101 Tech Ave', 'Brampton', 'Ontario', 'L6Y 2Y4', 'Canada',
  TO_DATE('2024-07-29', 'YYYY-MM-DD'), 'ohassan', 'omarpass'
);

INSERT INTO Customer VALUES (
  10, 'Rachel', 'Brown', 'rachel@example.com', '416-890-5678',
  '37 Cloud Ct', 'Scarborough', 'Ontario', 'M1K 4J2', 'Canada',
  TO_DATE('2024-08-09', 'YYYY-MM-DD'), 'rbrown', 'brownsecure'
);

-- Insert Sample Data into Vendor (10 Rows)

INSERT INTO Vendor VALUES (201, 'TechNova Inc.', 'contact@technova.com', '416-111-2222', '55 Innovation Way', 'Toronto', 'Ontario', 'M1A 2B3', 'Canada');
INSERT INTO Vendor VALUES (202, 'AeroFlex Shoes', 'support@aeroflex.com', '416-222-3333', '88 Runner Lane', 'Mississauga', 'Ontario', 'L5B 1C2', 'Canada');
INSERT INTO Vendor VALUES (203, 'ChronoSync Wearables', 'info@chronosync.com', '416-333-4444', '77 Smart Ave', 'Brampton', 'Ontario', 'L6T 3Y4', 'Canada');
INSERT INTO Vendor VALUES (204, 'KitchenPro Tools', 'sales@kitchenpro.com', '416-444-5555', '12 Chef Blvd', 'Vaughan', 'Ontario', 'L4K 4B9', 'Canada');
INSERT INTO Vendor VALUES (205, 'FashionHub Apparel', 'hello@fashionhub.ca', '416-555-6666', '999 Style Street', 'Scarborough', 'Ontario', 'M1W 2N2', 'Canada');
INSERT INTO Vendor VALUES (206, 'EcoStore Supplies', 'eco@ecostore.ca', '416-666-7777', '22 Earth Crescent', 'Richmond Hill', 'Ontario', 'L3T 2G3', 'Canada');
INSERT INTO Vendor VALUES (207, 'GamingTech Gear', 'rgb@gamingtech.com', '416-777-8888', '101 Pixel Place', 'Toronto', 'Ontario', 'M5A 1T1', 'Canada');
INSERT INTO Vendor VALUES (208, 'ZoomAudio Canada', 'audio@zoomaudio.com', '416-888-9999', '33 Sound St', 'Etobicoke', 'Ontario', 'M8V 2V3', 'Canada');
INSERT INTO Vendor VALUES (209, 'HomeComforts Ltd.', 'relax@homecomforts.com', '416-999-0000', '45 Pillow Pkwy', 'Markham', 'Ontario', 'L6E 1M7', 'Canada');
INSERT INTO Vendor VALUES (210, 'SpeedRunners Co.', 'run@speedrunners.com', '416-000-1111', '7 Track Road', 'Pickering', 'Ontario', 'L1V 1N5', 'Canada');

--Insert Sample Data into Product (10 Rows)

INSERT INTO Product VALUES (101, 201, 'NovaCore X15 Gaming Laptop', 'High-performance laptop with RTX graphics and 1TB SSD.', 1499.99, 25, 'Electronics', '/images/laptop.jpg');
INSERT INTO Product VALUES (102, 202, 'AeroFlex RunPro Sneakers', 'Lightweight running shoes with breathable mesh.', 89.99, 50, 'Footwear', '/images/sneakers.jpg');
INSERT INTO Product VALUES (103, 203, 'ChronoSync Smartwatch S4', 'Smartwatch with fitness tracking and Bluetooth connectivity.', 199.99, 40, 'Wearables', '/images/smartwatch.jpg');
INSERT INTO Product VALUES (104, 204, 'KitchenPro Elite Knife Set', 'Professional stainless steel knife set with ergonomic handles.', 129.99, 30, 'Kitchenware', '/images/knifeset.jpg');
INSERT INTO Product VALUES (105, 205, 'FashionHub Denim Jacket', 'Stylish denim jacket with modern fit and durable stitching.', 79.99, 45, 'Apparel', '/images/denimjacket.jpg');
INSERT INTO Product VALUES (106, 206, 'EcoStore Reusable Bottle 1L', 'Eco-friendly water bottle made from BPA-free materials.', 24.99, 60, 'Accessories', '/images/bottle.jpg');
INSERT INTO Product VALUES (107, 207, 'GamingTech RGB Mechanical Keyboard', 'Mechanical keyboard with customizable RGB lighting.', 109.99, 35, 'Electronics', '/images/keyboard.jpg');
INSERT INTO Product VALUES (108, 208, 'ZoomAudio Wireless Headphones', 'Noise-cancelling headphones with 20-hour battery life.', 149.99, 40, 'Audio', '/images/headphones.jpg');
INSERT INTO Product VALUES (109, 209, 'HomeComforts Memory Foam Pillow', 'Ergonomic pillow with cooling gel and memory foam.', 39.99, 55, 'Home', '/images/pillow.jpg');
INSERT INTO Product VALUES (110, 210, 'SpeedRunners Performance Socks (5-pack)', 'Moisture-wicking socks designed for athletes.', 29.99, 70, 'Footwear', '/images/socks.jpg');

-- Insert Sample Data into CustomerOrder (10 Rows)

INSERT INTO CustomerOrder VALUES (301, 1, TO_DATE('2025-07-01', 'YYYY-MM-DD'), 'Shipped', '123 Tech Street, Toronto', 1589.98);
INSERT INTO CustomerOrder VALUES (302, 2, TO_DATE('2025-07-02', 'YYYY-MM-DD'), 'Delivered', '456 Market Ave, Mississauga', 89.99);
INSERT INTO CustomerOrder VALUES (303, 3, TO_DATE('2025-07-03', 'YYYY-MM-DD'), 'Pending', '789 Bay Street, Toronto', 199.99);
INSERT INTO CustomerOrder VALUES (304, 4, TO_DATE('2025-07-04', 'YYYY-MM-DD'), 'Delivered', '321 Queen St, Toronto', 109.99);
INSERT INTO CustomerOrder VALUES (305, 5, TO_DATE('2025-07-05', 'YYYY-MM-DD'), 'Shipped', '456 Dundas St, Mississauga', 79.99);
INSERT INTO CustomerOrder VALUES (306, 6, TO_DATE('2025-07-06', 'YYYY-MM-DD'), 'Pending', '987 Elm St, Markham', 129.99);
INSERT INTO CustomerOrder VALUES (307, 7, TO_DATE('2025-07-07', 'YYYY-MM-DD'), 'Delivered', '654 Sunset Blvd, Richmond Hill', 149.99);
INSERT INTO CustomerOrder VALUES (308, 8, TO_DATE('2025-07-08', 'YYYY-MM-DD'), 'Shipped', '222 Green Ln, Pickering', 39.99);
INSERT INTO CustomerOrder VALUES (309, 9, TO_DATE('2025-07-09', 'YYYY-MM-DD'), 'Delivered', '101 Tech Ave, Brampton', 24.99);
INSERT INTO CustomerOrder VALUES (310, 10, TO_DATE('2025-07-10', 'YYYY-MM-DD'), 'Pending', '37 Cloud Ct, Scarborough', 29.99);

--Insert Sample Data into OrderItem (10 Rows)

INSERT INTO OrderItem VALUES (401, 301, 101, 1, 1499.99);
INSERT INTO OrderItem VALUES (402, 302, 102, 1, 89.99);
INSERT INTO OrderItem VALUES (403, 303, 103, 1, 199.99);
INSERT INTO OrderItem VALUES (404, 304, 107, 1, 109.99);
INSERT INTO OrderItem VALUES (405, 305, 105, 1, 79.99);
INSERT INTO OrderItem VALUES (406, 306, 104, 1, 129.99);
INSERT INTO OrderItem VALUES (407, 307, 108, 1, 149.99);
INSERT INTO OrderItem VALUES (408, 308, 109, 1, 39.99);
INSERT INTO OrderItem VALUES (409, 309, 106, 1, 24.99);
INSERT INTO OrderItem VALUES (410, 310, 110, 1, 29.99);

-- Insert Sample Data into Cart (10 Rows)

INSERT INTO Cart VALUES (501, 1, TO_DATE('2025-07-01', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (502, 2, TO_DATE('2025-07-02', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (503, 3, TO_DATE('2025-07-03', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (504, 4, TO_DATE('2025-07-04', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (505, 5, TO_DATE('2025-07-05', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (506, 6, TO_DATE('2025-07-06', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (507, 7, TO_DATE('2025-07-07', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (508, 8, TO_DATE('2025-07-08', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (509, 9, TO_DATE('2025-07-09', 'YYYY-MM-DD'));
INSERT INTO Cart VALUES (510, 10, TO_DATE('2025-07-10', 'YYYY-MM-DD'));

--Insert Sample Data into CartProduct (10 Rows)

INSERT INTO CartProduct VALUES (601, 501, 101, 1);
INSERT INTO CartProduct VALUES (602, 502, 102, 2);
INSERT INTO CartProduct VALUES (603, 503, 103, 1);
INSERT INTO CartProduct VALUES (604, 504, 107, 1);
INSERT INTO CartProduct VALUES (605, 505, 105, 3);
INSERT INTO CartProduct VALUES (606, 506, 104, 1);
INSERT INTO CartProduct VALUES (607, 507, 108, 2);
INSERT INTO CartProduct VALUES (608, 508, 109, 1);
INSERT INTO CartProduct VALUES (609, 509, 106, 2);
INSERT INTO CartProduct VALUES (610, 510, 110, 1);

--Insert Sample Data into Wishlist (10 Rows)

INSERT INTO Wishlist VALUES (701, 1, 101, TO_DATE('2025-07-01', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (702, 2, 102, TO_DATE('2025-07-02', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (703, 3, 103, TO_DATE('2025-07-03', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (704, 4, 104, TO_DATE('2025-07-04', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (705, 5, 105, TO_DATE('2025-07-05', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (706, 6, 106, TO_DATE('2025-07-06', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (707, 7, 107, TO_DATE('2025-07-07', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (708, 8, 108, TO_DATE('2025-07-08', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (709, 9, 109, TO_DATE('2025-07-09', 'YYYY-MM-DD'));
INSERT INTO Wishlist VALUES (710, 10, 110, TO_DATE('2025-07-10', 'YYYY-MM-DD'));

-- Insert Sample Data into ReturnRequest (10 Rows)

INSERT INTO ReturnRequest VALUES (801, 401, TO_DATE('2025-07-02', 'YYYY-MM-DD'), 'Wrong item delivered', 'Pending');
INSERT INTO ReturnRequest VALUES (802, 402, TO_DATE('2025-07-03', 'YYYY-MM-DD'), 'Size too small', 'Approved');
INSERT INTO ReturnRequest VALUES (803, 403, TO_DATE('2025-07-04', 'YYYY-MM-DD'), 'Defective product', 'Rejected');
INSERT INTO ReturnRequest VALUES (804, 404, TO_DATE('2025-07-05', 'YYYY-MM-DD'), 'Changed mind', 'Pending');
INSERT INTO ReturnRequest VALUES (805, 405, TO_DATE('2025-07-06', 'YYYY-MM-DD'), 'Late delivery', 'Approved');
INSERT INTO ReturnRequest VALUES (806, 406, TO_DATE('2025-07-07', 'YYYY-MM-DD'), 'Product not as described', 'Pending');
INSERT INTO ReturnRequest VALUES (807, 407, TO_DATE('2025-07-08', 'YYYY-MM-DD'), 'Duplicate order', 'Rejected');
INSERT INTO ReturnRequest VALUES (808, 408, TO_DATE('2025-07-09', 'YYYY-MM-DD'), 'Wrong color', 'Approved');
INSERT INTO ReturnRequest VALUES (809, 409, TO_DATE('2025-07-10', 'YYYY-MM-DD'), 'Missing accessories', 'Pending');
INSERT INTO ReturnRequest VALUES (810, 410, TO_DATE('2025-07-11', 'YYYY-MM-DD'), 'Received damaged item', 'Approved');

commit;