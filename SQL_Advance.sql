-- Q1 : Find how much amount spent by each customer on artists?
--Write a query to return customer name, artist name and total spent.

With best_selling_artist as(
     select artist.artist_id as artist_id, artist.name as artist_name,
	 sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	 from invoice_line
	 join track on invoice_line.track_id = track.track_id 
     join album on track.album_id = album.album_id
     join artist on album.artist_id = artist.artist_id
	 group by artist.artist_id
	 order by total_sales desc
	 limit 1
	 )

select c.customer_id,c.first_name,c.last_name,bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spend
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id= i.invoice_id
join track t on t.track_id = il.track_id 
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by c.customer_id,c.first_name,c.last_name,bsa.artist_name
order by amount_spend desc;

-- Q2 : We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the genre the highest amount of purchases.
--Write a query that returns each country along with the top Genre.
--For countries where the maximum number of purchases is shared return all Genreselect purchases,country,name,genre_id from (

select purchases, country, name, genre_id
from (
    select 
        count(invoice_line.quantity) as purchases,
        customer.country,
        genre.name,
        genre.genre_id,
        row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as rn
    from 
        customer
    join invoice on customer.customer_id = invoice.customer_id
    join invoice_line on invoice.invoice_id = invoice_line.invoice_id
    join track on invoice_line.track_id = track.track_id
    join genre on track.genre_id = genre.genre_id
    group by customer.country, genre.name, genre.genre_id
) as x
where x.rn <= 1
order by country asc, purchases desc;

--Q3 : Write a query that determines the customer that has spent the most on music for each country.
--Write a query that returns the country along with the top customer and how much they spent.
--For countries where the top amount spent is shared, provide all customer who spent this amount.
 


