/* Q1: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent.*/

with best_selling_artist as (
	select ar.artist_id as Artist_id, ar.name as Artist_name, sum(il.quantity * il.unit_price) as total_sales
	from invoice_line il 
	join track t on t.track_id = il.track_id
	join album a on a.album_id = t.album_id
	join artist ar on ar.artist_id = a.artist_id
	group by ar.artist_id
	order by Artist_id
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.quantity * il.unit_price) as total_spent
from customer c 
join invoice i on i.customer_id = c.customer_id 
join invoice_line il on i.invoice_id = il.invoice_id
join track t on t.track_id = il.track_id
join album a on a.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = a.artist_id
group by 1,2,3,4
order by 1;

/* Q2: We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with highest amount purchases.
write a query that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all genres.*/

with popular_genre as (

select count(il.unit_price) as purchases, c.country, g.genre_id, g.name,
row_number() over(partition by c.country order by count(il.unit_price) desc) as row_no
from invoice_line il
join invoice i on i.invoice_id = il.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id = il.track_id
join genre g on g.genre_id = t.genre_id
group by 2,3,4
order by 2 asc, 1 desc
)
select * from popular_genre where row_no <= 1;


/* Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with recursive customer_with_country as (
select c.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) as amount_spent
from invoice i join customer c on c.customer_id = i.customer_id
group by 1,2,3,4
order by 1,5 desc
),
country_max_spending as(
select billing_country, max(amount_spent) as Max_spending
from customer_with_country
group by billing_country
)

select cc.customer_id,  cc.first_name, cc.last_name, cc.billing_country, cc.amount_spent
from customer_with_country cc
join country_max_spending cs
on cc.billing_country = cs.billing_country
where cc.amount_spent = cs.Max_spending
order by 1;

/* easy method*/
with top_customer_country as(
select c.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) as amount_spent,
row_number() over(partition by i.billing_country order by sum(i.total) desc) as Rownumber
from invoice i join customer c on c.customer_id = i.customer_id
group by 1,2,3,4
order by 1,5 desc
)
select * from top_customer_country where Rownumber = 1;