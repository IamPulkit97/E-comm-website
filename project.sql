select * from olist_geolocation_dataset
Select * from olist_order_items_dataset
Select * from olist_order_payments_dataset
select * from olist_order_reviews_dataset
SELECT * from olist_products_dataset
select * from olist_sellers_dataset
select * from product_category_name_translation
select * from olist_customers_dataset
select distinct customer_id from olist_orders_dataset

--assumption that the first order of the cx was the date of joining 
with a as (
select distinct olist_orders_dataset.customer_id, min (order_purchase_timestamp) as joining,customer_state 
from olist_orders_dataset 
inner join olist_customers_dataset 
on olist_orders_dataset.customer_id=olist_customers_dataset.customer_id
group by olist_orders_dataset.customer_id,customer_state)
select count(a.customer_id)as count_,year(joining)as yr,customer_state from a 
group by year(joining),customer_state
order by year(joining)

---total no. or orders
with a as (
select year(order_purchase_timestamp) as yr, count(order_id) as order_s,customer_state 
from olist_orders_dataset 
inner join olist_customers_dataset 
on olist_orders_dataset.customer_id=olist_customers_dataset.customer_id
group by year(order_purchase_timestamp),customer_state)
select yr,customer_state ,order_s from a 
group by yr,customer_state, order_s
order by yr

---total no of sales
Select * from olist_order_payments_dataset
select * from olist_orders_dataset

with a as(
select year(order_purchase_timestamp) as yr, sum(payment_value) as total_pay,customer_state 
from olist_orders_dataset 
inner join olist_order_payments_dataset  
on olist_orders_dataset.order_id=olist_order_payments_dataset.order_id
inner join olist_customers_dataset
on olist_orders_dataset.customer_id=olist_customers_dataset.customer_id
group by year(order_purchase_timestamp),customer_state) 
select yr,customer_state ,total_pay from a 
group by yr,customer_state, total_pay
order by yr

---- declining trend over the years 
create or alter view a as(select yr,customer_state ,total_pay from (
select year(order_purchase_timestamp) as yr, sum(payment_value) as total_pay,customer_state 
from olist_orders_dataset 
inner join olist_order_payments_dataset  
on olist_orders_dataset.order_id=olist_order_payments_dataset.order_id
inner join olist_customers_dataset
on olist_orders_dataset.customer_id=olist_customers_dataset.customer_id
where year(order_purchase_timestamp)=2016
group by year(order_purchase_timestamp),customer_state) a
group by yr,customer_state, total_pay);

create or alter view b as(select yr,customer_state ,total_pay from (
select year(order_purchase_timestamp) as yr, sum(payment_value) as total_pay,customer_state 
from olist_orders_dataset 
inner join olist_order_payments_dataset  
on olist_orders_dataset.order_id=olist_order_payments_dataset.order_id
inner join olist_customers_dataset
on olist_orders_dataset.customer_id=olist_customers_dataset.customer_id
where year(order_purchase_timestamp)=2017
group by year(order_purchase_timestamp),customer_state) a
group by yr,customer_state, total_pay);


create or alter view c as(select yr,customer_state ,total_pay from (
select year(order_purchase_timestamp) as yr, sum(payment_value) as total_pay,customer_state 
from olist_orders_dataset 
inner join olist_order_payments_dataset  
on olist_orders_dataset.order_id=olist_order_payments_dataset.order_id
inner join olist_customers_dataset
on olist_orders_dataset.customer_id=olist_customers_dataset.customer_id
where year(order_purchase_timestamp)=2018
group by year(order_purchase_timestamp),customer_state) a
group by yr,customer_state, total_pay);


select c.customer_state,a.total_pay as '2016',b.total_pay as '2017',c.total_pay as '2018' from a right join b 
on a.customer_state=b.customer_state right join 
c on b.customer_state=c.customer_state

-- review over the years
select year(order_purchase_timestamp) as yr,case when review_score = 1 then count(r.order_ID)
when review_score = 2 then count(r.order_ID) 
when review_score = 3 then count(r.order_ID) 
when review_score = 4 then count(r.order_ID) 
when review_score = 5 then count(r.order_ID) end as t  from olist_order_reviews_dataset r join olist_orders_dataset o on 
r.order_id=o.order_id group by review_score,year(order_purchase_timestamp)

select customer_state,year(order_purchase_timestamp) as yr,case when review_score = 1 then count(r.order_ID)
when review_score = 2 then count(r.order_ID) 
when review_score = 3 then count(r.order_ID) 
when review_score = 4 then count(r.order_ID) 
when review_score = 5 then count(r.order_ID) end as t  from olist_order_reviews_dataset r join olist_orders_dataset o on 
r.order_id=o.order_id join olist_customers_dataset c on c.customer_id=o.customer_id 
where customer_state in ('se')
group by review_score,year(order_purchase_timestamp),customer_state

select customer_state,year(order_purchase_timestamp) as yr,case when review_score = 1 then count(r.order_ID)
when review_score = 2 then count(r.order_ID) 
when review_score = 3 then count(r.order_ID) 
when review_score = 4 then count(r.order_ID) 
when review_score = 5 then count(r.order_ID) end as t  from olist_order_reviews_dataset r join olist_orders_dataset o on 
r.order_id=o.order_id join olist_customers_dataset c on c.customer_id=o.customer_id 
where customer_state in ('sp')
group by review_score,year(order_purchase_timestamp),customer_state

----delivery time
select * from olist_orders_dataset
Select * from olist_order_items_dataset
select * from olist_sellers_dataset
select * from olist_customers_dataset

select c.customer_city,customer_state,order_estimated_delivery_date,order_delivered_customer_date,
datediff(day,order_estimated_delivery_date,order_delivered_customer_date),s.seller_state
from olist_orders_dataset o join olist_order_items_dataset d 
on o.order_id=d.order_id join 
olist_sellers_dataset s on d.seller_id=s.seller_id join olist_customers_dataset c 
on c.customer_id=o.customer_id
where c.customer_state='se' and datediff(day,order_estimated_delivery_date,order_delivered_customer_date)<0


select c.customer_city,customer_state,order_estimated_delivery_date,order_delivered_customer_date,
datediff(day,order_estimated_delivery_date,order_delivered_customer_date),s.seller_state
from olist_orders_dataset o join olist_order_items_dataset d 
on o.order_id=d.order_id join 
olist_sellers_dataset s on d.seller_id=s.seller_id join olist_customers_dataset c 
on c.customer_id=o.customer_id
where c.customer_state='sp' and datediff(day,order_estimated_delivery_date,order_delivered_customer_date)<0

select c.customer_city,customer_state,order_estimated_delivery_date,order_delivered_customer_date,
datediff(day,order_estimated_delivery_date,order_delivered_customer_date),s.seller_state
from olist_orders_dataset o join olist_order_items_dataset d 
on o.order_id=d.order_id join 
olist_sellers_dataset s on d.seller_id=s.seller_id join olist_customers_dataset c 
on c.customer_id=o.customer_id
where c.customer_state='al' and datediff(day,order_estimated_delivery_date,order_delivered_customer_date)<0




