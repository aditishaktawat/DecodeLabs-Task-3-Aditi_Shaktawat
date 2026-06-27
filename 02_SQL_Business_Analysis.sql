
-- # Section 1: Data Understanding

/* Q1. How many total orders exist? */

Select count(*)
from orders;

/* Q2. How many unique customers exist? */

Select count(distinct(customerid))
from orders;

-- # Section 2: Revenue Analysis

-- Q3. What is total revenue?

Select round(sum(totalprice ::numeric),2) as total_revenue
FROM orders;

-- Q4. What is average order value?

SELECT AVG(totalprice)
FROM orders;

-- Q5. Which products generate highest revenue?

Select product, Sum(totalprice) as total_revenue
From orders
group by product
order by total_revenue desc;

--Q6. Which products sell highest quantity?

Select product,sum(quantity) as quantity
From orders
group by product
order by quantity desc;

-- # Section 3: Category Analysis

--Q7. Which category contributes maximum revenue?

Select product_category, round(sum(totalprice::numeric),2) as revenue
from orders
group by product_category
order by revenue desc;

-- # Section 4: Customer Analysis

-- Q8. Who are the top 10 customers by spending?

Select customerid, round(sum(totalprice::numeric),2) as revenue
from orders
group by customerid
order by revenue desc;

-- Q9. Which customers placed multiple orders?

Select customerid, count(orderid) as orders
from orders
group by customerid HAVING count(orderid) > 1;

-- # Section 5: Order Performance

-- Q10. Order status distribution?

Select orderstatus, count(orderid) as count
from orders
group by orderstatus
order by count desc;

-- Q11. Delivery rate?

WITH delivered AS (
  SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN orderstatus = 'Delivered' THEN 1 ELSE 0 END) AS deliver
  FROM orders	
)
SELECT 
  ROUND((deliver * 100.0) / total_orders, 2) AS delivery_rate
FROM delivered;

-- Q12. Which status loses most orders?

SELECT 
  orderstatus, 
  COUNT(orderid) AS total_lost_orders,
  ROUND(SUM(totalprice::numeric), 2) AS lost_revenue
FROM orders
WHERE orderstatus IN ('Cancelled', 'Returned') 
GROUP BY orderstatus
ORDER BY total_lost_orders DESC;

-- # Section 6: Discount Analysis

-- Q13. How many orders used discounts?

Select count(orderid)
from orders 
where couponcode != 'None';


-- Q14. Do discounts increase AOV?

SELECT 
  ROUND(AVG(CASE WHEN couponcode IS NULL OR couponcode = 'None' THEN totalprice::numeric END), 2) AS baseline_aov,
  ROUND(AVG(CASE WHEN couponcode IS NOT NULL AND couponcode != 'None' THEN totalprice::numeric END), 2) AS discounted_aov
FROM orders;

--OR Using A/B TEST
SELECT 
  CASE 
    WHEN couponcode IS NULL OR couponcode = 'None' THEN 'Control (No Discount)' 
    ELSE 'Variant (Discount Applied)' 
  END AS test_group,
  COUNT(orderid) AS total_orders,
  ROUND(AVG(totalprice::numeric), 2) AS aov
FROM orders
GROUP BY 
  CASE 
    WHEN couponcode IS NULL OR couponcode = 'None' THEN 'Control (No Discount)' 
    ELSE 'Variant (Discount Applied)' 
  END;

SELECT
couponcode,
COUNT(orderid) AS orders,
AVG(totalprice) AS avg_order_value
FROM orders
GROUP BY couponcode
order by avg_order_value desc;

--Q15. Which 3 products have the highest % of purchases with discounts applied?
SELECT
    product,
    COUNT(orderid) AS total_orders,
    SUM(
        CASE 
            WHEN couponcode <> 'None' THEN 1
            ELSE 0
        END) AS discounted_orders,
    ROUND(
        100.0 *
        SUM(CASE 
                WHEN couponcode <> 'None' THEN 1 ELSE 0
            END) / COUNT(orderid),2
    ) AS discount_percentage
FROM orders
GROUP BY product HAVING COUNT(orderid) > 20
ORDER BY discount_percentage DESC;

-- Q16. Which couponcode generate highest revenue?
Select couponcode, 
	COUNT(orderid) AS total_orders,
	round(Sum(totalprice::numeric),2) as total_revenue,
	round(AVG(totalprice::numeric),2) AS avg_order_value
From orders
group by couponcode
order by total_revenue desc;

-- # Section 7: Payment Analysis

-- Q17. Which payment method is most popular?

Select paymentmethod, count(orderid) as order_count
from orders
group by paymentmethod
order by order_count desc;

-- Q18. Which payment generates highest revenue?

Select paymentmethod, round(sum(totalprice::numeric),2) as revenue
from orders
group by paymentmethod
order by revenue desc;

-- # Section 8: Marketing Analysis

-- Q19. Which referral source brings most customers?

Select referralsource, count(customerid) as cust_count
from orders
group by referralsource
order by cust_count desc;

-- Q20.  Which referral generates maximum revenue?

Select referralsource, round(sum(totalprice::numeric),2) as revenue
from orders
group by referralsource
order by revenue desc;


-- # Section 9: Time Analysis

-- Q21. Monthly revenue trend

SELECT 
  DATE_TRUNC('month', date) AS order_month, 
  round(SUM(totalprice::numeric),2) AS revenue
FROM orders
GROUP BY DATE_TRUNC('month', date)
ORDER BY order_month ASC;

-- Q22. Month On Month Growth Rate

WITH monthly_growth AS (
  SELECT 
    DATE_TRUNC('month', date) AS month,
    ROUND(SUM(totalprice::NUMERIC), 2) AS current_revenue,
    LAG(ROUND(SUM(totalprice::NUMERIC), 2)) OVER(ORDER BY DATE_TRUNC('month', date)) AS previous_month_revenue
  FROM orders
  GROUP BY DATE_TRUNC('month', date) 
)

SELECT 
  month,
  current_revenue,
  previous_month_revenue,
  ROUND(100.0 * (current_revenue - previous_month_revenue) / previous_month_revenue, 2) AS mom_growth_rate
FROM monthly_growth
ORDER BY month ASC;

-- Q23. 7 Day Rolling Average

WITH daily_revenue AS (
  -- Step 1: Calculate total revenue per day
  SELECT 
    DATE_TRUNC('day', date) AS order_day,
    SUM(totalprice::numeric) AS daily_total
  FROM orders
  GROUP BY DATE_TRUNC('day', date)
)

-- Step 2: Calculate the rolling average across the daily totals
SELECT 
  order_day,
  daily_total,
  ROUND(AVG(daily_total) OVER (
    ORDER BY order_day 
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 2) AS rolling_7d_avg
FROM daily_revenue
ORDER BY order_day ASC;


-- Q24. Yearly revenue trend

Select order_year, round(sum(totalprice::numeric),2)
from orders
group by order_year
ORDER BY order_year;

# Section 10: Advanced Analyst Questions

-- Q25. Top 2 products per category

WITH prod_rank as (
Select product,
	product_category,
	round(sum(totalprice::numeric),2) as revenue,
	ROW_NUMBER() OVER ( PARTITION BY product_category 
	  ORDER BY round(sum(totalprice::numeric),2)DESC)
		as rnk
From orders
group by product, product_category
)

Select product,
	product_category,
	revenue,
	rnk
from prod_rank
where rnk < 3;

-- Q26. Product Revenue contribution %

WITH contribution AS (
  SELECT 
    product,
    SUM(totalprice::numeric) AS revenue
  FROM orders
  GROUP BY product
)

SELECT 
  product,
  revenue,
  ROUND(100.0 * revenue / SUM(revenue) OVER(), 2) AS revenue_perct
FROM contribution
ORDER BY revenue_perct DESC;


-- Q27. VIP customers

WITH customer_spend AS (
  -- Step 1: Calculate total lifetime value (LTV) per customer
  SELECT 
    customerid,
    SUM(totalprice) AS lifetime_spend,
    COUNT(orderid) AS total_orders
  FROM orders
  GROUP BY customerid
),
ranked_customers AS (
  -- Step 2: Rank them based on who spent the most
  SELECT 
    customerid,
    lifetime_spend,
    total_orders,
    DENSE_RANK() OVER (ORDER BY lifetime_spend DESC) AS spend_rank
  FROM customer_spend
)

-- Step 3: Isolate the true VIPs
SELECT * FROM ranked_customers
WHERE spend_rank <= 10;

-- ======================================
-- Results Export Queries
-- Used for generating CSV files

-- ======================================
-- Revenue Analysis Export
-- ======================================
SELECT
round(SUM(totalprice::numeric),2) AS total_revenue,
round(AVG(totalprice::numeric),2) AS average_order_value,
COUNT(orderid) AS total_orders
FROM orders;

-- ======================================
-- Product Analysis Export
-- Covers:
-- Q5  Product revenue contribution
-- Q6  Product quantity sold
-- Q23 Top products per category
-- Q24 Revenue contribution %
-- ======================================

WITH product_revenue AS
(
    SELECT
        product,
        product_category,
        SUM(quantity) AS units_sold,
        ROUND(SUM(totalprice::numeric),2) AS revenue
    FROM orders
    GROUP BY product, product_category
)
SELECT product,
    product_category,
    units_sold,
    revenue,
    ROUND( revenue * 100 /SUM(revenue) OVER(),
        2) AS revenue_contribution_percentage,
    DENSE_RANK() OVER(
        PARTITION BY product_category
        ORDER BY revenue DESC
    ) AS category_rank
FROM product_revenue
ORDER BY revenue DESC;

-- ======================================
-- Category Analysis Export
-- ======================================

Select product_category, round(sum(totalprice::numeric),2) as revenue
from orders
group by product_category
order by revenue desc;

-- ======================================
-- Customer Analysis Export
-- Covers:
-- Q8  Top customers by spending
-- Q9  Repeat customers
-- Q25 VIP customers
-- ======================================
WITH customer_metrics AS
(
    SELECT
        customerid,
        COUNT(orderid) AS total_orders,
        ROUND(SUM(totalprice::numeric),2) AS total_spending,
        ROUND(AVG(totalprice::numeric),2) AS average_order_value
    FROM orders
    GROUP BY customerid
)
SELECT
    customerid,
    total_orders,
    total_spending,
    average_order_value,
    CASE
        WHEN total_orders = 1 THEN 'One Time Customer'
        	ELSE 'Repeat Customer'
		END AS customer_type,
    CASE
        WHEN total_spending < 1000 THEN 'Budget Customer'
        WHEN total_spending <= 3000 THEN 'Standard Customer'
            ELSE 'VIP Customer'
		END AS customer_segment
FROM customer_metrics
ORDER BY total_spending DESC;

-- ======================================
-- Operations Analysis Export
-- ======================================

SELECT 
    orderstatus,
    COUNT(orderid) AS total_orders,
    ROUND( COUNT(orderid) * 100.0 /(SELECT COUNT(*) FROM orders)) AS order_percentage,
    ROUND( SUM(totalprice::numeric),2) AS revenue,
    CASE
        WHEN orderstatus = 'Delivered' THEN 'Successful'
        WHEN orderstatus IN ('Cancelled','Returned') THEN 'Lost'
        ELSE 'In Progress'
    END AS order_category
FROM orders
GROUP BY orderstatus
ORDER BY total_orders DESC;

-- ======================================
-- Discount Analysis Export
-- Discount usage and AOV comparison
-- ======================================

SELECT
CASE WHEN couponcode='None'
		THEN 'No Discount'
	ELSE 'Discount Applied'
END AS discount_status,
COUNT(orderid) AS orders,
ROUND(AVG(totalprice::numeric),2) AS avg_order_value,
ROUND(SUM(totalprice::numeric),2) AS revenue

FROM orders
GROUP BY discount_status
ORDER BY revenue desc;

-- ======================================
-- Marketing Analysis Export
-- ======================================
SELECT
referralsource,
COUNT(customerid) AS customers,
round(SUM(totalprice::numeric),2) AS revenue
FROM orders
GROUP BY referralsource
order by revenue desc;

-- ======================================
-- Time Trend Analysis Export
-- Covers:
-- Q19 Monthly Revenue Trend
-- Q20 Month-over-Month Growth
-- Q21 7 Day Rolling Average
-- Q22 Yearly Revenue Trend
-- ======================================

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC('month', date) AS month,
        EXTRACT(YEAR FROM date) AS order_year,
        ROUND(
            SUM(totalprice::numeric),2)
				AS monthly_revenue
    FROM orders
    GROUP BY 
        DATE_TRUNC('month', date),
        EXTRACT(YEAR FROM date)
),

monthly_growth AS
(
    SELECT month,
        order_year,
        monthly_revenue,
        LAG(monthly_revenue)
        OVER( ORDER BY month) 
			AS previous_month_revenue
    FROM monthly_revenue
),

daily_revenue AS
(
    SELECT
        DATE_TRUNC('day', date) AS order_day,
        SUM(totalprice::numeric) AS daily_total
    FROM orders
    GROUP BY DATE_TRUNC('day', date)
),
daily_rolling AS
(
    SELECT
        order_day,
        ROUND(
            AVG(daily_total) OVER(
                ORDER BY order_day
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2)
				AS rolling_7_day_avg
    FROM daily_revenue
),

monthly_rolling AS
(
    SELECT
        DATE_TRUNC('month', order_day) AS month,
        ROUND( AVG(rolling_7_day_avg), 2) 
				AS avg_rolling_7_day_revenue
    FROM daily_rolling
    GROUP BY DATE_TRUNC('month', order_day)
)
SELECT
    m.order_year,
    m.month,
    m.monthly_revenue,
    m.previous_month_revenue,
    ROUND(
        100.0 *
        (m.monthly_revenue - m.previous_month_revenue) / m.previous_month_revenue, 2)
			AS mom_growth_rate,

    mr.avg_rolling_7_day_revenue
	
FROM monthly_growth m
LEFT JOIN monthly_rolling mr
ON m.month = mr.month
ORDER BY m.month;
