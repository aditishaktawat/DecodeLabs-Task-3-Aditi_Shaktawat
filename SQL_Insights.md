# E-Commerce SQL Analysis Insights

## 1. Business Overview

- Total Orders: 1200
- Total Products: 7
- Total Revenue: $1.26M
- Average Order Value: $1053.96


### Business Interpretation

The dataset represents a healthy e-commerce transaction system with high-value average orders.

# 2. Revenue Analysis

## Key Findings

- Total revenue generated: $ 1264761.96
- AOV:  $ 1053.96

## Business Action

Focus on increasing repeat purchases and improving customer lifetime value.


## 3. Product Performance

## Key Findings

Highest Revenue Products:

1. Chair - $195,620
2. Printer - $195,612


Highest Quantity Sold:

1. Chair - 562 units
2. Printer - 542 units


Lowest Performing:

Phone generated lowest revenue:
$151,722


## Business Action

Inventory and marketing efforts should prioritize high-performing products and maintain inventory availability for high performing products..


# 4. Category Revenue

     Electronics - $ 901681.91
     Furniture - $ 363080.04

Qunatity sold: 
    Electronics - 852
    Furniture - 348


## Insight

Electronics dominates revenue contribution and should receive higher strategic focus.

# 5. Customer Analysis 

- Unique Customers: 1189
- Repeat Customers: 11

## Insight

Large customer base but low repeat purchase behavior.

Potential opportunity: Improve retention strategies.


# 6. Operations Analysis

Order status distribution: 

       "Cancelled"	250
       "Returned"	  247
       "Pending"	  237
       "Shipped"	  235
       "Delivered"	231

Delivery rate:   19.25%

## Insight

Low delivery success indicates possible operational issues.

Investigate:
- Shipping delays
- Cancellation reasons
- Return causes


# 7. Discount Analysis

- Orders who used discounts - **891**

- Dicounted AOV = **$ 1057.64**
- No discount AOV = **$ 1043.37**

Discounted orders generated approximately **$14.27 higher average order value (~1.37% increase)** compared to non-discounted orders.

## Insight

Discounts appear to slightly increase customer spending behaviour.

However, the impact is relatively small, indicating that discounts should be evaluated carefully to ensure they improve revenue quality and not only increase transaction volume.

---
## Product Discount Dependency Analysis

### Findings

Products were ranked based on the percentage of purchases made using discounts.

Top products with higher discount dependency:

1. Printer - **76.8%** discounted purchases
2. Desk - **75.8%** discounted purchases
3. Phone - **75%** discounted purchases


## Business Insight

Products with high discount dependency may indicate:

- price sensitivity among customers
- customers waiting for promotional offers
- need for pricing or positioning review
---

## Coupon Performance Analysis

### Findings

Coupons were analyzed based on:
- number of orders generated
- revenue contribution
- average order value

Top revenue-generating coupons:

1. FREESHIP - $ 335037 revenue
2. SAVE10 - $ 30480 revenue

## Business Insight

Not all coupons create the same business value.

High-performing coupons can be prioritized for future marketing campaigns, while low-performing coupons should be reviewed.

---

## Overall Discount Analysis Conclusion

Discounts are contributing positively to purchase behaviour, but the business should balance promotional activity with profitability and customer retention goals.

# 8. Payment Analysis

Most preffered payment method- 'Online'

Least preffered payment method- 'Gift Card'

    "Online"	      258
    "Cash"	        246
    "Credit Card"	  234
    "Debit Card"	  232
    "Gift Card"	    230

Which payment generates highest revenue? 
  "Credit Card" : $ 263847.63

Which payment generates least revenue?
  "Debit Card" " $ 232361.18

## Insight

Online payment channels dominate customer preference.


# 9. Marketing Analysis

Best referral source:   "Instagram"

## Insight

Instagram brings the strongest customer acquisition.

# 11. Product Revenue contribution %
     "Printer"	195612.61	   15.47
     "Chair"	  195620.11	   15.47
     "Laptop"	  192126.56	   15.19
     "Tablet"	  186568.95	   14.75
     "Monitor"	175651.41	   13.89
     "Desk"	    167459.93	   13.24
     "Phone"	  151722.39	   12.00

## Insight

Revenue is evenly distributed across products, reducing dependency on a single product.


# 11. Time Trend Analysis:

## Monthly Revenue Trend (Q19)

### Key Findings

- The highest revenue month was **June 2024** with revenue of **$68,068.54**.

- The lowest revenue month was **April 2023** with revenue of **$27,751.71**.


### Business Interpretation

Monthly revenue analysis shows fluctuations in customer demand over time.

The peak in June 2024 indicates a period of strong customer activity, which could be linked to:
- successful marketing campaigns
- increased customer acquisition
- seasonal demand patterns

The low revenue periods highlight months where business performance weakened and require further investigation.


### Business Action

The company can use monthly trends to:
- plan inventory requirements
- schedule promotional campaigns during low-demand periods
- identify seasonal buying patterns

---


## Month-over-Month Revenue Growth Analysis (Q20)

### Key Findings

- Highest MoM growth occurred in **June 2024** with a growth rate of **143.89%** compared to the previous month.

- The largest revenue decline occurred in **September 2023** with a decline of **45.68%**.


### Business Interpretation

MoM growth helps measure the speed at which revenue is increasing or decreasing.

A strong positive growth month indicates increased demand and successful business activities.

A sharp decline may indicate:

- reduced customer engagement
- lower product demand
- ineffective promotions
- operational issues


### Business Action

Growth spikes should be investigated to identify successful strategies that can be repeated.

Declining months should be analyzed using:

- customer retention metrics
- product performance
- marketing channel performance

---

## 7-Day Rolling Revenue Average (Q21)

### Key Findings

- A 7-day rolling average was calculated to smooth daily revenue fluctuations.
- The rolling revenue average ranged approximately between:
  - Lowest: **$1,148.42**
  - Highest: **$2,515.04**


### Business Interpretation

Daily revenue can be highly volatile.

The rolling average helps identify the underlying business trend by reducing short-term noise.

This allows the business to differentiate between:
- temporary revenue spikes
- consistent growth patterns


### Business Action

Rolling trends can support:

- short-term revenue forecasting
- inventory planning
- operational resource allocation

---

## Yearly Revenue Trend (Q22)
 2023 - $ 552643.24
 2024 - $ 480235.87
 2025 - $ 231882.85

### Business Interpretation

The analysis shows a decline in yearly revenue over time.

Revenue decreased:
- 2024 vs 2023 → approximately **13% decline**
- 2025 vs 2024 → approximately **52% decline**

### Business Action

The decline suggests the need to investigate:
- customer retention
- repeat purchase behavior
- product demand changes
- marketing effectiveness

Additional analysis should focus on identifying the reason behind declining revenue and strategies to recover growth.
   

