-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS frequency;

CREATE TABLE employees(
   id SERIAL PRIMARY KEY,
   email VARCHAR(50),
   name VARCHAR(30)
   );

CREATE TABLE products(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE sales(
  id SERIAL PRIMARY KEY,
  invoice_no INTEGER,
  sale_date DATE,
  sale_amount MONEY,
  units INTEGER,
  employee_id INTEGER,
  product_id INTEGER,
  account_id INTEGER,
  frequency_id INTEGER
);

CREATE TABLE accounts(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  account_no VARCHAR(15)
);

CREATE TABLE frequency(
  id SERIAL PRIMARY KEY,
  occurrence TEXT
);
