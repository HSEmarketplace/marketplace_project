set search_path = demo_db, public;



-- Получить суммарную стоимость товаров по категориям и 
-- отсортировать их в порядке убывания суммарной стоимости
select category_id, sum(price) as total_price
from goods
group by category_id
order by sum(price) desc;


-- Получить топ-3 товаров с самым высоким средним рейтингом 
-- и самым большим количеством отзывов в порядке убывания
select g.good_id, g.naming, avg(r.rating) as average_rating, count(r.review_id) as review_count
from goods g
join reviews r on g.good_id = r.product_id
group by g.good_id, g.naming
order by avg(r.rating) desc, count(r.review_id) desc
limit 3;


-- Для каждого пользователя получить идентификаторы его покупок, 
-- отсортированных по дате покупки в убывающем порядке, и 
-- добавить номера строк для каждой группы пользователей
select user_id, purchase_id, date_of_purchase,
       row_number() over(partition by user_id order by date_of_purchase desc) as row_num
from purchases;


-- для каждого пользователя определить, сколько всего покупок 
-- он совершил по сравнению с другими пользователями
select user_id, count(purchase_id) as purchase_count,
       rank() over(order by count(purchase_id) desc) as purchase_count_rank
from purchases
group by user_id;


-- определить для каждого товара количество отзывов, 
-- полученных в течение месяца с момента его появления на складе
with reviews_per_month as (
  select product_id, date_of_review,
         count(review_id) over(partition by product_id, date_trunc('month', date_of_review)) as reviews_count
  from reviews
)
select r.product_id, r.date_of_review, r.reviews_count
from reviews_per_month r
join goods g on r.product_id = g.good_id;
