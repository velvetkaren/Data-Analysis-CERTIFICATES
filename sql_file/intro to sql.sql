create database Orders; -- by Karen Ogiugo

use Orders;

-- 1. display entire data from products table

SELECT * from product;

-- 2. display only address_ID, city, state and pincode columns from adress table

select address_id, city, state, pincode
from address;

-- 3. display unique cities in the address table

select distinct city
from address;

-- 4. delete all records from products table whose product_id is 99999

delete 
from product 
where product_id = 99999;

select *
from product;

-- 5. update the price of all products table to a 25% lesser values
set sql_safe_updates = 0;
update product 
set product_price = product_price-(product_price*0.25);
select *
from product;

-- 6. display the top 10 rows from address table

select * 
from address
limit 10;

-- 1. display all the records from address table where state = 'NY'

select * 
from address
where state = 'NY';
-- 2. Fetch the records from the adress table for NY, CT and AL states


select * 
from address 
where state in ('NY', 'CT', 'AL');

-- 3. Fetch the records from the address table where state is not null

select * 
from address
where state is not null;


-- 4. fetch the records from the address where city name starts with the letter 'b' 
-- b% means that letter B will be followed by any number of characters

select * 
from address 
where city like 'b%';


-- 5. fetch the records from address table where city name contains exactly 5 letters
-- _ is to match any single character, or example to match 3 characters three underscores will be specified

select * 
from address 
where city like '_____';


-- 6. fetch all the records from the products table whose price is between 5000 and 10000

select *
from product
where product_price between 5000 and 10000;



-- 7. fetch all the records from products table where product price is less than 1000 and quantity available is more than 100

select *
from product 
where product_price < 1000 and product_quantity_avail > 100;


-- 6. fetch all the records from products table where product price is less than 1000 or quantity available is less than 50


select *
from product 
where product_price < 1000 or product_quantity_avail < 50;


-- 1. find the total number of records in the product table
select count(*) as cnt
from product;


-- 2.1 fetch sum of product price and average product price for each product_class_code

-- 2.2 select only the product classes that have an average price >= 4000
select product_class_code, sum(product_price) as total_price, avg(poduct_price) as avg_price
from product
group by product_class_code
having avg_price >= 4000;

-- 3. fetch total number of male and female customers - use online_customer table


select customer_gender, count(customer_gender) as gender_count
from online_customer
group by customer_gender;
-- 4. display the count of unqiue cities in the address table

select count(distinct city) as unique_cities
from address;


/* 5. check your inventory stock 
if quantity is less than or equal to 50, call it "low stock"
if quantity is greater than 50 and less or equal to 150, call it "medium stock" 
if quantity is greater than 150, "high stock"
*/ 


select product_id, product_desc, product_class_code, product_quantity_avail,
case
when product_quantity_avail <= 50 then 'LOW STOCK'
when product_quantity_avail > 50 then 'MEDIUM STOCK'
when product_quantity_avail > 150 then 'HIGH STOCK'
end as availability_status
from product;




-- 1. fetch all the products which fall under electronics category - (use
-- product and product_class category)
-- upper() converts the names of all product_class_description to upper case.
-- lower() converts the names of all product_class_description to lower case.

select *
from product as pr
inner join product_class as pc
on pc.product_class_code = pr.product_class_code
where upper(product_class_desc) = 'ELECTRONICS';


-- 2. query cusromer_id, customer full name, order_id, product_quantity of customers
-- who bought more than 10 items
-- use tables online_customer, order_header, order_items


select 
oc.customer_id,
concat(oc.customer_fname, ' ', oc.customer_lname) as full_name,
oh.order_id,
sum(oi.product_quantity) as total_purchase_quantity
from online_customer oc
inner join order_header oh
on oc.customer_id = oh.customer_id
inner join order_items oi
on oh.order_id = oi.order_id
group by
oc.customer_id,
full_name,
oh.order_id
having total_purchase_quantity > 10;

-- 3. fetch all the products which have not been ordered yet

select 
product_id,
product_desc,
product_price,
oi.product_quantity
from product
left join order_items oi using(product_id)
where oi.product_quantity is null;

-- 4. write a query to fetch all the product category description whose average price is > 5000

select 
pr.product_class_code,
pc.product_class_desc,
avg(product_price) as average_product_price
from product pr
inner join product_class pc using(product_class_code)
group by product_class_code
having average_product_price > 5000;

-- 5. write a query to get all the columns and rows both order_header and order_items

select * from order_header oh
left join order_items on oh.order_id = order_items.order_id
union
select * from order_header oh
right join order_items on oh.order_id = order_items.order_id;