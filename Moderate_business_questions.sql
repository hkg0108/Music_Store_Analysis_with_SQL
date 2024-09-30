/*Q1: Write a query to return the email, firstname, lastname with Genre of all Rock music listeners.
Return your list ordered alphabetically by email starting with A.
*/
select distinct c.email, c.first_name, c.last_name
from customer c join invoice i on i.customer_id = c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
where track_id in (
select track_id  from track t
join genre g on g.genre_id = t.genre_id
where g.name like 'Rock')
order by c.email asc;

/*Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the artist name and total track count of top 10 rock bands.
*/

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from artist  join album al on al.artist_id = artist.artist_id
join track t on t.album_id = al.album_id 
join genre g on g.genre_id = t.genre_id
where g.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the name and miliseconds for each track. Order by song length with longest songs listed first. */


select track_id, name, milliseconds  
from track 
where milliseconds > (select avg(milliseconds) as avg_length from track)
order by milliseconds desc;