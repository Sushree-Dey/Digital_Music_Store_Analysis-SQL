--Q1 : Who is the senior most employee baesd on job title?

select * from employee order by levels desc limit 1;

--Q2 : Which countries have the most invoices?

select count(*) as invoices_count, billing_country
from invoice
group by billing_country
order by invoices_count desc ;

--Q3 : What are top 3 values of total invoice?

select total from invoice order by total desc limit 3;

select total from (
select total,
row_number() over(order by total desc) as rn
from invoice ) as x
where x.rn<=3;

--Q4 : Which city has the best customer?

select billing_city,sum(total) as sum_invoices from invoice
group by billing_city order by sum_invoices desc;

--Q5 : Who is the best customer? 
--The customer who spent the most money will be decalared the best customer. 
--Write a query that returns the person who has spent the most money.

select customer.customer_id, customer.first_name,customer.last_name, sum(invoice.total) as sum_invoice
from customer 
join invoice on
customer.customer_id = invoice.customer_id
group by customer.customer_id, customer.first_name,customer.last_name
order by sum_invoice  desc limit 1;



