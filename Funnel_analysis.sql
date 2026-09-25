CREATE DATABASE marketing_funnel;
USE marketing_funnel;
SELECT COUNT(*) 
FROM funnel_data;
SELECT *
FROM funnel_data
LIMIT 10;
SELECT
    COUNT(*) AS total_visitors,
    SUM(Visited_Product) AS product_viewed,
    SUM(Added_to_Cart) AS added_to_cart,
    SUM(Started_Checkout) AS checkout_started,
    SUM(Purchased) AS purchased
FROM funnel_data;
SELECT DISTINCT Visited_Product
FROM funnel_data;
SELECT
    COUNT(*) AS total_visitors,
    SUM(Visited_Product IN ('1','TRUE','true')) AS product_viewed,
    SUM(Added_to_Cart IN ('1','TRUE','true')) AS added_to_cart,
    SUM(Started_Checkout IN ('1','TRUE','true')) AS checkout_started,
    SUM(Purchased IN ('1','TRUE','true')) AS purchased
FROM funnel_data;

SELECT
    Visited_Product,
    LENGTH(Visited_Product) AS value_length,
    HEX(Visited_Product) AS stored_value,
    COUNT(*) AS total
FROM funnel_data
GROUP BY Visited_Product;
SELECT
    COUNT(*) AS total_visitors,

    SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END) AS product_viewed,

    SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END) AS added_to_cart,

    SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END) AS checkout_started,

    SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END) AS purchased

FROM funnel_data;
SELECT
    'Visitors to Product View' AS funnel_stage,
    COUNT(*) AS starting_visitors,
    SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END) AS next_stage,
    ROUND(
        SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS conversion_rate
FROM funnel_data

UNION ALL

SELECT
    'Product View to Cart',
    SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END) * 100.0
        / SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END), 2
    )
FROM funnel_data

UNION ALL

SELECT
    'Cart to Checkout',
    SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END) * 100.0
        / SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END), 2
    )
FROM funnel_data

UNION ALL

SELECT
    'Checkout to Purchase',
    SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END) * 100.0
        / SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END), 2
    )
FROM funnel_data;

SELECT
    Source,
    COUNT(*) AS total_visitors,

    SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END) AS product_viewed,

    SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END) AS added_to_cart,

    SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END) AS checkout_started,

    SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END) AS purchased,

    ROUND(
        SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS conversion_rate

FROM funnel_data
GROUP BY Source
ORDER BY conversion_rate DESC;

SELECT
    Device,
    COUNT(*) AS total_visitors,

    SUM(CASE WHEN Visited_Product = 'True' THEN 1 ELSE 0 END) AS product_viewed,

    SUM(CASE WHEN Added_to_Cart = 'True' THEN 1 ELSE 0 END) AS added_to_cart,

    SUM(CASE WHEN Started_Checkout = 'True' THEN 1 ELSE 0 END) AS checkout_started,

    SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END) AS purchased,

    ROUND(
        SUM(CASE WHEN Purchased = 'True' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS conversion_rate

FROM funnel_data
GROUP BY Device
ORDER BY conversion_rate DESC;

