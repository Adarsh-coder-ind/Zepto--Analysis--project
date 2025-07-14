use zepto;

create table zepto (
sku_id serial primary key,
category varchar(120),
name varchar (150) not null,
mrp numeric(8,2),
discountPercentage numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outofstock boolean,
quantity integer
);

ALTER TABLE zepto
DROP COLUMN sku_id;

#data Explorations
select count(*) from zepto.zepto_v2;

#count of rows

select *from zepto.zepto_v2
limit 10;

 SELECT *
FROM zepto.zepto_v2
WHERE name IS NULL
         OR Category IS NULL
         OR mrp IS NULL
         OR discountPercent IS NULL
         OR availableQuantity IS NULL
         OR discountedSellingPrice IS NULL
         OR weightInGms IS NULL
         OR outOfStock IS NULL
         OR quantity IS NULL;


#select distinct category
select distinct category
from zepto.zepto_v2
order by Category;

#product in stock vs out of stock 

SELECT
  outOfStock,
  COUNT(*) AS count_per_status
FROM zepto.zepto_v2
GROUP BY outOfStock;


#product name present multiple times

SELECT 
  name,
  COUNT(Category) AS number_of_unique_categories
FROM zepto.zepto_v2
GROUP BY name
HAVING COUNT(Category) > 0
ORDER BY number_of_unique_categories DESC
LIMIT 100;

#Data Cleaning 

#product with price = 0 

select *from  zepto.zepto_v2
where mrp = 0 or discountedSellingPrice = 0;

 SELECT DISTINCT mrp
FROM zepto.zepto_v2
WHERE mrp LIKE '%0%';

SELECT COUNT(*) AS cnt
FROM zepto.zepto_v2
WHERE mrp = 0;



#update zepto paise to rupess
update zepto.zepto_v2
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;


# find the top 10 best value product based on the discount percentage 
 select distinct name , mrp discountPercent
 from zepto.zepto_v2
 order by discountPercent desc
 limit 10;
 
 #what are the product with high MRP but out of stock

SELECT name, mrp
FROM zepto.zepto_v2
WHERE mrp > 300
ORDER BY mrp DESC
LIMIT 10;

-- Any out-of-stock items?
SELECT name, outOfStock
FROM zepto.zepto_v2
WHERE outOfStock = TRUE
LIMIT 5;


# Calculate Estimate Revenue For Each Category
select category,
sum(discountedSellingPrice * availableQuantity) as Total_Revenue
from zepto.zepto_v2
group by category
order by Total_Revenue;

#Find all product where mrp is greater then 500 Rupees and discount is less than 10%

select distinct name , mrp , discountPercent
from zepto.zepto_v2
where mrp > 500 And discountPercent < 10
order by mrp desc, discountPercent desc;

# identify the top 5 Category offering the highest average discount percentage 

select category,
Round(Avg(discountPercent),2) As avg_discount
from zepto.zepto_v2
group by category
order by avg_discount desc
limit 5 ;

#find the price per gram for product above 100g and sort by best value

select distinct name , weightInGms , discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) AS price_per_gram
from zepto.zepto_v2
where weightInGms >= 100
order by price_per_gram;

#Group the product into category like low medium , bulk
select distinct name, weightInGms,
case when weightInGms <1000 then 'low'
     when weightInGms <5000 then 'Medium'
     else 'bulk'
     End as weight_category
     from zepto.zepto_v2;
     
   #If you want to count how many products are in each category:  
     SELECT
  CASE 
    WHEN weightInGms < 1000 THEN 'low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'bulk'
  END AS weight_category,
  COUNT(*) AS product_count
FROM zepto.zepto_v2
GROUP BY CASE 
  WHEN weightInGms < 1000 THEN 'low'
  WHEN weightInGms < 5000 THEN 'Medium'
  ELSE 'bulk'
END;

#what is the total inventory weight per category

select category ,
sum(weightInGms * availableQuantity) AS Total_weight
from zepto.zepto_v2
group by category
order by Total_weight;





#

