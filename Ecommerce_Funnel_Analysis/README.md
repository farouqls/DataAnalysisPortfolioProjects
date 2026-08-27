# E-Commerce Conversion Funnel Analysis

## Skills Used
Excel | SQL (MySQL) | Tableau | Data Cleaning | Funnel Analysis | Hypothesis Testing

## Data Source
[Kaggle — E-commerce Conversion Funnel Dataset](https://www.kaggle.com/datasets/deepeshkansotia/e-commerce-conversion-funnel-dataset): 100,000 user sessions simulating e-commerce engagement, from initial visit to purchase.

## Funnel Stages
**Visited → Viewed Product → Added to Cart → Converted**

(Stages were defined from the dataset's behavioral columns, since the raw data provides session-level features rather than an explicit stage log: `product_views > 0`, `cart_additions > 0`, `converted = 1`.)

## Project Summary
- Cleaned 100,000 rows in Excel: verified no missing values, no true duplicate rows, and no impossible values across all key columns.
- Wrote SQL funnel queries in MySQL to count sessions at each stage and calculate stage-to-stage conversion rates.
- Tested three hypotheses (bounce behavior, discount level, time on site) to explain the drop-off — all three were ruled out, narrowing the likely cause down to checkout-flow friction.
- Built an interactive Tableau dashboard visualizing the funnel, conversion rates, and segment comparisons.

## Key Findings

**Funnel overview:**
| Stage | Sessions | % of Start |
|---|---|---|
| Visited | 100,000 | 100.00% |
| Viewed Product | 96,075 | 96.08% |
| Added to Cart | 96,234 | 96.23% |
| Converted | 49,752 | 49.75% |

**Biggest drop-off:** Added to Cart → Converted, where only **51.7%** of sessions that added an item to cart went on to complete a purchase — nearly half of cart sessions abandon before checkout.

**Data limitation note:** the Viewed Product → Added to Cart transition calculates to just over 100% (100.17%), since `cart_additions` (96,234) is marginally higher than `product_views` (96,075) in the raw data. This suggests the funnel stages in this synthetic dataset were generated as independent features rather than a strictly sequential user journey — flagged here as a known limitation rather than an analysis error.

**What's driving the abandonment? Three hypotheses tested, all ruled out:**

| Variable | Finding |
|---|---|
| Bounce behavior | No effect (49.60% vs 49.84% conversion) |
| Discount level | No effect (48.87%–50.30% across all bands, no trend) |
| Time on site | No effect (49.46%–49.92% across all bands) |

Conversion rate stayed remarkably flat (~49–50%) regardless of user engagement or pricing incentive — ruling out both as likely causes of cart abandonment.

## Recommendation
Cart abandonment (48.3%) is the single biggest funnel leak, and it appears unrelated to user engagement or discounting. This points toward **structural friction in the checkout process** — such as payment issues, unexpected shipping costs, or forced account creation — as the likely cause. Recommend instrumenting checkout-step-level events (e.g. payment page reached, shipping page reached) to pinpoint exactly where in checkout users drop off.

## Dashboard
preview
<img width="1848" height="830" alt="E-com Conversion Funnel" src="https://github.com/user-attachments/assets/2bad9679-57ee-43e6-a3f5-49c276d19c62" />


📊 [View the interactive dashboard on Tableau Public] https://public.tableau.com/views/Book1_17870566566140/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link




