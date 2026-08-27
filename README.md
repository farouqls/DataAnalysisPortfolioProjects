# Cafe Sales — Excel Data Cleaning & Interactive Dashboard

## Skills Used
Excel | Data Cleaning | Logical Imputation | Formulas (IF, OR, ISBLANK, IFERROR, TEXT, YEAR) | PivotTables | PivotCharts | Slicers | Dashboard Design

## Data Source
[Kaggle — Cafe Sales: Dirty Data for Cleaning Training](https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training): 10,000 cafe transactions, deliberately messy — missing values, "ERROR" and "UNKNOWN" placeholder text scattered across numeric, text, and date fields.

## Project Summary
- Diagnosed the mess: every field checked for blanks, "ERROR," and "UNKNOWN" values using an `OR()`/`ISBLANK()` flagging system, quantified column by column before any cleaning began.
- Recovered missing values mathematically where possible: since `Quantity × Price Per Unit = Total Spent`, any single missing field in that trio was recalculated from the other two. Rows with two or more broken fields in the trio were left as `N/A`, since guessing would mean fabricating data.
- Cleaned non-numeric fields (Item, Location, Payment Method) by replacing blanks/errors with an explicit **"Unknown"** label rather than deleting the row — a missing location doesn't mean the sale didn't happen, and deleting it would have understated total revenue.
- Handled broken transaction dates by leaving them blank rather than inserting a fake date, which would have distorted the monthly/weekday trend charts. Revenue and item-level totals still include these rows; only the time-based charts exclude them, and that exclusion is labeled "Unknown" rather than hidden.
- Extracted Month, Year, and Weekday from transaction dates using `TEXT()` and `YEAR()`, with Custom Lists set up so months and weekdays sort in calendar order instead of alphabetically.
- Built 6 PivotTables and matching PivotCharts, connected to a shared set of Slicers (Item, Month, Location, Payment Method, Weekday) so the whole dashboard filters together from a single click.

## Key Metrics
| Metric | Value |
|---|---|
| Total Revenue | 88,952 |
| Total Transactions | 10,000 |
| Total Quantity Sold | 30,141 |
| Average Order Value | 8.92 |

## Key Findings
- **Best-selling item:** Salad leads by revenue, followed by Smoothie and Sandwich.
- **Revenue by month:** relatively stable year-round (6,800–7,350 per month), with no single month standing out as a strong seasonal peak.
- **Busiest day:** Thursday narrowly leads (12,394), with Friday and Sunday close behind — no single day dramatically outperforms the rest.
- **In-store vs Takeaway:** close to an even split between the two, with a notable share of transactions missing a recorded location (labeled "Unknown" rather than excluded).
- **Payment method:** Cash, Credit Card, and Digital Wallet are used at nearly identical rates (~20,000–20,400 each) — no dominant payment preference among cafe customers.
- **Data quality note:** roughly a third of the dataset had at least one missing or invalid field; the cleaning approach preserved as much real revenue and transaction history as possible rather than discarding incomplete rows outright.

## Dashboard
![Dashboard Preview
<img width="1915" height="855" alt="Dashboard preview" src="https://github.com/user-attachments/assets/f523ed97-20c2-4d81-be6a-7bec68ec3546" />



Interactive slicers (Item, Month, Location, Payment Method, Weekday) filter all charts and KPI cards simultaneously.

## Files
- `dirty_cafe_sales_project.xlsx` — full workbook: raw data, cleaning formulas, PivotTables, and Dashboard
- `dashboard_preview.png` — static preview of the dashboard
