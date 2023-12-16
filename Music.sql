select * from  employee order by levels desc

select billing_country ,count(*) from  invoice
group by billing_country order by count(*) desc 

select total from  invoice
 order by total desc limit 3
 
select billing_city ,sum(total) from  invoice 
group by billing_city order by sum(total) desc limit 1

select concat(first_name,'',last_name),sum(total) from  customer a
join invoice b
on a.customer_id=b.customer_id
group by concat(first_name,'',last_name) order by sum(total) desc limit 1

select email,
first_name,
last_name
from  customer a
join invoice b
on a.customer_id=b.customer_id
join invoice_line c
on b.invoice_id=c.invoice_id
join track d
on c.track_id=d.track_id
join genre e
on e.genre_id=d.genre_id
where e.name='Rock'
order by email

select a.name as artist_name,
count(a.artist_id)
from artist a
join
album b
on a.artist_id=b.artist_id
join track c
on b.album_id=c.album_id
where c.genre_id in(select genre_id from genre where name='Rock')
group by a.name order by count(c.track_id) desc limit 10 

select name,milliseconds
from track where
milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc

select * from invoice_line

select concat(first_name,last_name) as customer_name,
f.name,
cast(sum(c.quantity*c.unit_price) as decimal) as Total_spent
from 
customer a
join
invoice b
on a.customer_id=b.customer_id
join invoice_line c
on b.invoice_id=c.invoice_id
join track d
on c.track_id=d.track_id
join album e
on e.album_id=d.album_id
join artist f
on e.artist_id=f.artist_id
group by concat(first_name,last_name) ,
f.name order by total_spent desc


with cte as(select e.country,
c.name,count(quantity) as cnt,
row_number() over(partition by e.country order by count(quantity) desc) as rn
from
invoice_line a
join track b
on a.track_id=b.track_id
join genre c
on c.genre_id=b.genre_id
join invoice d
on a.invoice_id=d.invoice_id
join customer e
on e.customer_id=d.customer_id		
group by e.country,c.name)

select * from
cte 
where rn<=1



with cte as(Select country,
concat(trim(first_name),',',trim(last_name)) as customer_name,
cast(sum(total) as decimal) as highest_purchase,
row_number() over(partition by country order by sum(total) desc) as rn 
from
customer a
join 
Invoice b
on a.customer_id=b.customer_id
group by country,
concat(trim(first_name),',',trim(last_name))
order by 1)
select country,
customer_name,
highest_purchase from
cte 
where rn<=1