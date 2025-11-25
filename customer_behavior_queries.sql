SELECT * FROM customer LIMIT 20;

Q1. Total revenue by gender

SELECT gender,
       SUM(purchase_amount_usd) AS total_revenue
FROM customer
GROUP BY gender;


---

Q2. Customers who used a discount and spent above average

SELECT customer_id, purchase_amount_usd
FROM customer
WHERE discount_applied = 'Yes'
  AND purchase_amount_usd > (SELECT AVG(purchase_amount_usd) FROM customer);


---

Q3. Top 5 products with highest average review rating

SELECT item_purchased,
       ROUND(AVG(review_rating::numeric), 2) AS avg_rating
FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;


---

Q4. Average purchase amount by shipping type (Standard vs. Express)

SELECT shipping_type,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_spend
FROM customer
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;


---

Q5. Do subscribed customers spend more?

SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_spend,
       SUM(purchase_amount_usd) AS total_revenue
FROM customer
GROUP BY subscription_status;


---

Q6. Top 5 products with the highest discount usage

SELECT item_purchased,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
       AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;


---

Q7. Customer segmentation by previous purchases

WITH segments AS (
    SELECT customer_id,
           previous_purchases,
           CASE 
               WHEN previous_purchases <= 1 THEN 'New'
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS segment
    FROM customer
)
SELECT segment,
       COUNT(*) AS total_customers
FROM segments
GROUP BY segment;


---

Q8. Top 3 most purchased items in each category

WITH ranked_items AS (
    SELECT category,
           item_purchased,
           COUNT(*) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS rn
    FROM customer
    GROUP BY category, item_purchased
)
SELECT category, item_purchased, total_orders
FROM ranked_items
WHERE rn <= 3;


---

Q9. Are repeat buyers (>5 past purchases) more likely to subscribe?

SELECT subscription_status,
       COUNT(*) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;


---

Q10. Revenue contribution by age group

WITH age_groups AS (
    SELECT customer_id, purchase_amount_usd,
           CASE
               WHEN age < 25 THEN '18-24'
               WHEN age BETWEEN 25 AND 34 THEN '25-34'
               WHEN age BETWEEN 35 AND 44 THEN '35-44'
               WHEN age BETWEEN 45 AND 54 THEN '45-54'
               ELSE '55+'
           END AS age_group
    FROM customer
)
SELECT age_group,
       SUM(purchase_amount_usd) AS total_revenue
FROM age_groups
GROUP BY age_group
ORDER BY total_revenue DESC;


---

Q11. Which shipping type generates the highest revenue?

SELECT shipping_type,
       SUM(purchase_amount_usd) AS total_revenue
FROM customer
GROUP BY shipping_type
ORDER BY total_revenue DESC;


---

Q12. Most popular item and category combinations

SELECT category, item_purchased,
       COUNT(*) AS total_orders
FROM customer
GROUP BY category, item_purchased
ORDER BY total_orders DESC;


---

Q13. Average review rating by season

SELECT season,
       ROUND(AVG(review_rating::numeric), 2) AS avg_rating
FROM customer
GROUP BY season
ORDER BY avg_rating DESC;


---

Q14. Payment method usage count

SELECT payment_method,
       COUNT(*) AS total_users
FROM customer
GROUP BY payment_method
ORDER BY total_users DESC;


---

Q15. How many customers used promo codes?

SELECT promo_code_used,
       COUNT(*) AS total_customers
FROM customer
GROUP BY promo_code_used;


---

