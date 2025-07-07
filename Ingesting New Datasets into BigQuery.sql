#Ingesting New Datasets into BigQuery
#a query to list the top 5 products with the highest stockLevel
SELECT
  *
FROM
  ecommerce.products
ORDER BY
  stockLevel DESC
LIMIT  5;

#Ingest a new dataset from a Google Spreadsheet
SELECT
  *,
  SAFE_DIVIDE(orderedQuantity,stockLevel) AS ratio
FROM
  ecommerce.products
WHERE
# include products that have been ordered and
# are 80% through their inventory
orderedQuantity > 0
AND SAFE_DIVIDE(orderedQuantity,stockLevel) >= .8
ORDER BY
  restockingLeadTime DESC;

#Query data from an external spreadsheet
SELECT * FROM ecommerce.products_comments WHERE comments IS NOT NULL