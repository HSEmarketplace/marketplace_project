set search_path = demo_db, public;


-- SELECT запрос для выбора отзывов и их товаров
select r.review_id, r.review, r.rating, r.date_of_review, g.naming as product_name
from reviews r
inner join goods g on r.product_id = g.good_id;

--- UPDATE запрос для изменения отзыва
update reviews
set rating = 9
where review_id = 5;
