/*
=====================================================
PROJECT: E-Commerce Conversion Funnel Analysis
DATASET: Kaggle - E-commerce Conversion Funnel Dataset (100,000 user sessions)
=====================================================
GOAL:
Analyze where users drop off in the conversion funnel and identify 
the biggest opportunity for improving conversion rate.

FUNNEL STAGES:
1. Visited        - all sessions (baseline)
2. Viewed Product  - product_views > 0
3. Added to Cart   - cart_additions > 0
4. Converted       - converted = 1

CORE QUESTIONS TO ANSWER:
1. How many sessions reach each stage of the funnel?
2. What is the conversion rate from one stage to the next?
3. Where is the single biggest drop-off point?
4. What business recommendation follows from this?
*/

-- Query 1: Count of sessions at each funnel stage
SELECT
    COUNT(*) AS total_visited,
    SUM(CASE WHEN product_views > 0 THEN 1 ELSE 0 END) AS viewed_product,
    SUM(CASE WHEN cart_additions > 0 THEN 1 ELSE 0 END) AS added_to_cart,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted
FROM funnel_analysis.generated_data_working_sheet;


-- Query 2: Stage-to-stage conversion rate (%)
SELECT
    ROUND(96075 / 100000 * 100, 2) AS visited_to_viewed_pct,
    ROUND(96234 / 96075 * 100, 2) AS viewed_to_cart_pct,
    ROUND(49752 / 96234 * 100, 2) AS cart_to_converted_pct,
    ROUND(49752 / 100000 * 100, 2) AS overall_conversion_pct;
    
    
    
    
    -- Query 3: Does bounce_flag affect conversion among users who added to cart?
SELECT
    bounce_flag,
    COUNT(*) AS sessions_added_to_cart,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted_count,
    ROUND(SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_pct
FROM funnel_analysis.generated_data_working_sheet
WHERE cart_additions > 0
GROUP BY bounce_flag;



-- Query 4: Does discount level affect conversion among cart sessions?
SELECT
    CASE
        WHEN discount_percent < 10 THEN '0-10%'
        WHEN discount_percent < 20 THEN '10-20%'
        WHEN discount_percent < 30 THEN '20-30%'
        WHEN discount_percent < 40 THEN '30-40%'
        ELSE '40%+'
    END AS discount_band,
    COUNT(*) AS sessions_added_to_cart,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted_count,
    ROUND(SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_pct
FROM funnel_analysis.generated_data_working_sheet
WHERE cart_additions > 0
GROUP BY discount_band
ORDER BY discount_band;



-- Query 5: Does time on site affect conversion among cart sessions?
SELECT
    CASE
        WHEN time_on_site_sec < 300 THEN 'Under 5 min'
        WHEN time_on_site_sec < 600 THEN '5-10 min'
        WHEN time_on_site_sec < 1200 THEN '10-20 min'
        WHEN time_on_site_sec < 1800 THEN '20-30 min'
        ELSE '30+ min'
    END AS time_band,
    COUNT(*) AS sessions_added_to_cart,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted_count,
    ROUND(SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_pct
FROM funnel_analysis.generated_data_working_sheet
WHERE cart_additions > 0
GROUP BY time_band
ORDER BY time_band;


select *
 FROM funnel_analysis.generated_data_working_sheet;
 
 
 
 

-- Query 1 (reshaped for Tableau): stage name + count, one row per stage
SELECT 'Visited' AS funnel_stage, COUNT(*) AS session_count, 1 AS stage_order
FROM funnel_analysis.generated_data_working_sheet

UNION ALL

SELECT 'Viewed Product', SUM(CASE WHEN product_views > 0 THEN 1 ELSE 0 END), 2
FROM funnel_analysis.generated_data_working_sheet

UNION ALL

SELECT 'Added to Cart', SUM(CASE WHEN cart_additions > 0 THEN 1 ELSE 0 END), 3
FROM funnel_analysis.generated_data_working_sheet

UNION ALL

SELECT 'Converted', SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END), 4
FROM funnel_analysis.generated_data_working_sheet

ORDER BY stage_order;



-- Query 2 (reshaped for Tableau): stage-to-stage conversion rate, one row per transition
SELECT 'Visited → Viewed Product' AS transition, 
       ROUND(96075 / 100000 * 100, 2) AS conversion_rate_pct, 
       1 AS transition_order
UNION ALL
SELECT 'Viewed Product → Added to Cart', 
       ROUND(96234 / 96075 * 100, 2), 
       2
UNION ALL
SELECT 'Added to Cart → Converted', 
       ROUND(49752 / 96234 * 100, 2), 
       3
UNION ALL
SELECT 'Overall (Visited → Converted)', 
       ROUND(49752 / 100000 * 100, 2), 
       4
ORDER BY transition_order;


-- -------------------------------------------------------
-- Query 3 (reshaped for Tableau): all 3 segment comparisons combined
SELECT 
    'Bounce Flag' AS segment_type,
    CASE WHEN bounce_flag = 1 THEN 'Bounced' ELSE 'Not Bounced' END AS segment_value,
    COUNT(*) AS sessions,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted_count,
    ROUND(SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_pct
FROM funnel_analysis.generated_data_working_sheet
WHERE cart_additions > 0
GROUP BY bounce_flag

UNION ALL

SELECT 
    'Discount Level' AS segment_type,
    CASE
        WHEN discount_percent < 10 THEN '0-10%'
        WHEN discount_percent < 20 THEN '10-20%'
        WHEN discount_percent < 30 THEN '20-30%'
        WHEN discount_percent < 40 THEN '30-40%'
        ELSE '40%+'
    END AS segment_value,
    COUNT(*) AS sessions,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted_count,
    ROUND(SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_pct
FROM funnel_analysis.generated_data_working_sheet
WHERE cart_additions > 0
GROUP BY segment_value

UNION ALL

SELECT 
    'Time on Site' AS segment_type,
    CASE
        WHEN time_on_site_sec < 300 THEN 'Under 5 min'
        WHEN time_on_site_sec < 600 THEN '5-10 min'
        WHEN time_on_site_sec < 1200 THEN '10-20 min'
        WHEN time_on_site_sec < 1800 THEN '20-30 min'
        ELSE '30+ min'
    END AS segment_value,
    COUNT(*) AS sessions,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) AS converted_count,
    ROUND(SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_pct
FROM funnel_analysis.generated_data_working_sheet
WHERE cart_additions > 0
GROUP BY segment_value
-- add this to the very end, after the last GROUP BY:
ORDER BY 
    FIELD(segment_type, 'Bounce Flag', 'Discount Level', 'Time on Site'),
    segment_value;
    
    
    
    
    
    
