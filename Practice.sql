/*           						PRACTICE
Q-1 : Find duplicate records in table
use table - employees | columns : first name and email
find employee's who's name and email are repeating. */

create database prac;

use prac;

use db251;
select *from employee;

alter table employee add column mail text;

update employee set
mail = 'abc@gmail.com' where eid = 1;

update employee set
mail = 'def@gmail.com' where eid = 2;

insert into employee values (11,'Rahul Sharma','Delhi','abc@gmail.com');

insert into employee values (12,'Priya Mehta','Pune','def@gmail.com');

insert into employee values (13,'Priya Mehta','Pune','ghi@gmail.com');

select name, mail, count(*) from employee
	group by name, mail having count(*) > 1 ;
	
## Q-2 : Retrive the second highest salary from employee table

use db1;

select *from employee;

alter table employee add column salary decimal(10,2);

update employee set salary = 1000;

update employee set salary = 2000
	where eid = 2;
    
update employee set salary = 3000
	where eid = 3;
    
update employee set salary = 6000
	where eid = 6;
    
select *from employee 
	order by salary desc limit 1 offset 1 ;
    
## Q-3 : Find employees without department
## tables : employee and department

create table empl( eid int, name text, did int);

create table dep( did int, name text);

insert into empl values(1,'A',1),(2,'B',2),(3,'C',null),(4,'D',null);

insert into dep values(1,'HR'),(2,'QA');

select *from empl;

drop table empl;

select *from dep;

select *from empl e left join dep d
	on e.did = d.did
   where d.did is null;


## Q-4 : Calculate total revenue per product

select *from sales;

select product_name,quantity, price_per_unit,(quantity*price_per_unit) as Revenue from sales;
    
select product_category, sum(quantity * price_per_unit) from sales group by product_category;
    
    
## Q-5 : Get the top 3 highest paid emps

select *from employee;

select *from employee order by salary desc limit 3;

## Q-6 : Customer made purchases but never returned products

select c.customer_id from customers c inner join orders o on
	c.customer_id = o.customer_id left join returns r on
	c.customer_id = r.customer_id
    where r.customer_id is null;

## Q-7 show the count of orders per customer

select distinct customer_name, count(order_id) as ord from sales group by customer_name order by ord desc;

select city, count(order_id) from sales group by city;

select*from sales where customer_name ='ranveer singh';

select count(distinct customer_name) from sales;

## Q-8 : Retrieve all employee who joined in 2023

select customer_name, new_order_date from sales where year(new_order_date) = 2023;

## Q-9 : Calculate avg order value per customer

select city,sum(quantity), sum(quantity*price_per_unit) from sales group by city;

select customer_name, quantity, price_per_unit, avg(quantity*price_per_unit) from sales group by customer_name,quantity,price_per_unit;

select city, avg(total_amount) from sales group by city;

select city, sum(total_amount) from sales group by city;

## Q-10 : Get the latest order placed by each customer

select product_category, new_order_date from sales order by new_order_date desc;

select distinct product_category, max(new_order_date) from sales group by product_category;

## Q-11 : Find product that were never. sold

select p.* from products p left join sales s on
	p.product_id = s.product_id 
    where s.product_id is null;
    
## Q-12 : Identify most selling product

select *from sales;

select product_category,sum(quantity) as sumn from sales group by product_category order by sumn desc limit 1;

## Q-13 : Get total revenue and no of orders per region

 select city, count(order_id) as Orders, sum(quantity*price_per_unit) as revenue from sales group by city; 

## Q-14 : How many customers placed more than 5 orders

select city, count(order_id) as quan from sales group by city having quan > 41;

select count(*) from ( select city, count(order_id) as quan from sales group by city having quan > 41) as b;

## Q-15 : Customers with orders above the averge order value

select city, sum(quantity), sum(quantity* price_per_unit) as OrderValue from sales 
				group by city 
                having ordervalue > ( select avg(cityavg) from ( select sum(quantity*price_per_unit) as cityavg from sales group by city) as a);

select city,avg(cityavg) from ( select city,sum(quantity*price_per_unit) as cityavg from sales group by city) as b group by city;

select avg(cityavg) from ( select city,sum(quantity*price_per_unit) as cityavg from sales group by city) as b;

select city,sum(quantity*price_per_unit) as cityavg from sales group by city;

## Q-16 : Find all employees hired on weekends

select *from sales where dayofweek(new_order_date) in (1,7);

select *from sales where dayname(new_order_date) in ('saturday','sunday');

## Q-17 : Find salary between 50k and 100k

SELECT *FROM SALES;

select product_category, total_amount from sales where total_amount between 10000 and 19000;

## Q-18 : Get monthly sales revenue and order count

select *from sales;

select month(new_order_date),count(order_id),sum(total_amount) from sales group by month(new_order_date) order by month(new_order_date);

select date_format(new_order_date,'%m %Y'),count(order_id) as Quantity,sum(quantity*price_per_unit) as Revenue from sales
		group by date_format(new_order_date,'%m %Y') order by date_format(new_order_date,'%m %Y') asc;


## Q-19 : Rank emplpyees by salary within each dept

select *from sales;

select product_Category, total_amount, dense_rank() over ( partition by product_category order by total_amount desc) as Ranks from sales;

select product_category, total_amount, Ranks from (
	select product_category, total_amount, dense_rank() over ( partition by product_category order by total_amount desc) as Ranks from sales) as t
	where ranks <=3; 
    
## Q-20 find customers who placed orders in every month of 2023
## orders : cust id, order date

select payment_mode, count(distinct month(new_order_date)) as cnt from sales 
	where year(new_order_date) = 2022
	group by payment_mode having cnt = 12 ;
	
## Q-21 Find moving avg of sales over last 3 days
## Orders : order date, total amount






## Q-22 : Identify first and last order date for each customer
## Orders : cust id, order date

select *from sales;

select city, min(new_order_date), max(new_order_date) from sales
	group by city;
    
## Q-23 : Show product sales distribution ( % of total revenue )
## Sales : product id, quantity, price

select city,sum(total_amount) as CityTotal,
	(sum(total_amount)/(select sum(total_amount) from sales))*100 '%'
    from sales group by city;
    
## Q-24 Find customers who made consecutive purchases

select city from ( 
	select city,new_order_date,lag(new_order_date) over (partition by city order by new_order_Date asc) as prev from sales) as t
		where datediff(new_order_date,prev) = 1;
    
    
select city from ( select city, new_order_date,
	lag(new_order_date) over ( partition by city order by new_order_date asc) as prevs
    from sales) as t
    where datediff(new_order_Date,prevs) = 1;
	
    
## Q-25 : Find churned customers ( no orders in last 6 months )

select *, sum(total_Amount) over (partition by city order by new_order_date) from sales;

select city from sales group by city having datediff(curdate(),max(new_order_date)) < 180;

select city from sales group by city having max(new_order_date) < date_sub(16-05-2024, interval 2 month);

SELECT city FROM sales 
WHERE new_order_date < DATE_SUB(CURDATE(), INTERVAL 180 DAY) GROUP BY city;



    
    
    
    
    
    