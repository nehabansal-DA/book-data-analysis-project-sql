create database sql_projects;
use sql_projects;
create table orders(
Order_Id int primary key,
Customer_ID	int,
Book_ID int,
Order_Date	date,
Quantity int,
Total_Amount decimal
);

create table books(
Book_ID	int primary key,
Title varchar(100),	
Author varchar(100),	
Genre varchar(100),	
Published_Year date,	
Price decimal,
Stock int
);

create table customers(
Customer_ID	int primary key,
Name varchar(100),	
Email varchar(100),
Phone varchar(100),	
City varchar(100),	
Country varchar(100)
);
describe books;
describe customers;
describe orders;
DROP TABLE books;
DROP TABLE CUSTOMERS;
DROP TABLE ORDERS;

----------------------------------------
-- 1) Retrieve all books in the "Fiction" genre:
select * from books
where genre = 'Fiction';

-- 2) Find books published after the year 1950:
select * from books
where published_year > 1950;

-- 3) List all customers from the Canada:
select * from customers
where country = "canada";

-- 4) Show orders placed in November 2023:
select * from orders
WHERE month(order_date) = 11 and year(order_date) = 2023;

-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock from books;

-- 6) Find the details of the most expensive book:
-- subquery
select max(price) from books;
-- finalquery
select * from books 
where price = (select max(price) from books);

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from customers
where customer_ID IN (select customer_ID from orders
where quantity > 1);

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount > 20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books
where stock = (select min(stock) from books);

-- 11) Calculate the total revenue generated from all orders:
select round(sum(total_amount),2) as total_revenue from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select genre, sum(quantity) as total_orders from books as b 
left join orders as o on b.book_ID = o.book_ID
group by 1;

-- 2) Find the average price of books in the "Fantasy" genre:
select round(avg(price),2) as avg_price from books
where genre = "Fantasy";

-- 3) List customers who have placed at least 2 orders:
select customer_ID from orders
group by customer_ID
having count(customer_ID) >= 2;

-- 4) Find the most frequently ordered book:
select book_id, count(*) as no_of_time_ordered from orders
group by 1
having count(*) = (select max(total_book) as max_ordered 
from (select count(*) as total_book from orders
group by book_id) as c1);

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books
where genre = 'fantasy'
order by price desc
limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select b.author as author,sum(o.quantity) as total_quantity from books as b 
left join orders as o on b.book_id = o.book_id
group by 1;

-- 7) List the cities where customers who spent over $30 are located:
select distinct city from customers
where customer_id in (select customer_id from orders 
where total_amount > 30);

-- 8) Find the customer who spent the most on orders:
select customer_id, sum(total_amount) as total_spend from orders
group by 1
order by total_spend desc
limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
with c1 as (select b.book_id as book_id, b.title as title, sum(o.quantity) as total_orders,
sum(b.stock) as stock 
from orders as o 
join books as b on o.book_id = b.book_id
group by 1,2)

select *, (stock - total_orders) as remaning_stock
from c1;
