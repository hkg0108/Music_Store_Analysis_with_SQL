/*Q1: Who is the senior most employee based on job title?
*/
select * from employee
order by levels desc


/*Q2: Which country have the most invoices?
*/
select billing_country, count(total) as total_invoice from invoice
group by billing_country
order by total_invoice desc


/*Q3:What are top 3 values of total invoice?
*/
select total from invoice
order by total desc
limit 3

/*
Q4: Which city has best customers? We would like to throw a promotional Music Festival in the city 
we made the most money. Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name and sum of all invoie totals.
*/
select billing_city, sum(total) as invoice_total
from invoice
group by billing_city 
order by invoice_total desc
limit 1

/*Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money.
*/
select c.customer_id, c.first_name, c.last_name, sum(i.total) as total from customer c join invoice i on i.customer_id = c.customer_id  
group by c.customer_id,c.first_name, c.last_name
order by total desc
limit 1