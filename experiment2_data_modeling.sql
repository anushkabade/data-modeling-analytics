
CREATE TABLE customers (\
    customer_id INT PRIMARY KEY,\
    name VARCHAR(100) NOT NULL,\
    email VARCHAR(100) UNIQUE,\
    city VARCHAR(50)\
);\
\
\
CREATE TABLE products (\
    product_id INT PRIMARY KEY,\
    name VARCHAR(100) NOT NULL,\
    category VARCHAR(50),\
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)\
);\
\
\
CREATE TABLE sales (\
    sale_id INT PRIMARY KEY,\
    customer_id INT NOT NULL,\
    sale_date DATE NOT NULL,\
    channel ENUM('Online','In-Store','Mobile') NOT NULL,\
    payment_method ENUM('Cash','Credit Card','UPI','Wallet') NOT NULL,\
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)\
);\
\
\
CREATE TABLE sales_items (\
    sale_item_id INT PRIMARY KEY,\
    sale_id INT NOT NULL,\
    product_id INT NOT NULL,\
    quantity INT NOT NULL CHECK (quantity > 0),\
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),\
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),\
    FOREIGN KEY (product_id) REFERENCES products(product_id)\
);\
\
\
\
\
INSERT INTO customers VALUES\
(1, 'John Doe', 'john.doe@example.com', 'New York'),\
(2, 'Jane Smith', 'jane.smith@example.com', 'Los Angeles'),\
(3, 'Alice Wong', 'alice.wong@example.com', 'San Francisco');\
\
\
INSERT INTO products VALUES\
(101, 'Laptop', 'Electronics', 1200.00),\
(102, 'Headphones', 'Electronics', 150.00),\
(103, 'Coffee Maker', 'Home Appliances', 80.00);\
\
\
INSERT INTO sales VALUES\
(1001, 1, '2025-08-05', 'Online', 'Credit Card'),\
(1002, 2, '2025-08-12', 'In-Store', 'Cash'),\
(1003, 1, '2025-08-20', 'Mobile', 'UPI');\
\
\
INSERT INTO sales_items VALUES\
(1, 1001, 101, 1, 1200.00),\
(2, 1001, 102, 2, 150.00),\
(3, 1002, 103, 1, 80.00),\
(4, 1003, 102, 1, 155.00); -- price deviation example\
\
\
\
\
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month,\
       SUM(si.quantity * si.unit_price) AS total_revenue\
FROM sales s\
JOIN sales_items si ON s.sale_id = si.sale_id\
GROUP BY month\
ORDER BY month;\
\
\
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month,\
       AVG(order_total) AS AOV\
FROM (\
    SELECT s.sale_id, SUM(si.quantity * si.unit_price) AS order_total\
    FROM sales s\
    JOIN sales_items si ON s.sale_id = si.sale_id\
    GROUP BY s.sale_id\
) AS totals\
GROUP BY month;\
\
-- Price Deviation per Product\
SELECT p.product_id, p.name,\
       AVG(si.unit_price - p.price) AS avg_price_deviation\
FROM sales_items si\
JOIN products p ON si.product_id = p.product_id\
GROUP BY p.product_id, p.name;\
}
