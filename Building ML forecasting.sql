 # select the sum of sales by date, and product_id casted to day from order_items, joined with products. Include the product name in the results. Round the total_sales field to two decimal places and order results by total_sales descending.
 SELECT
     DATE(order_items.created_at) AS order_date,
     order_items.product_id,
     products.name AS product_name,
     ROUND(SUM(order_items.sale_price), 2) AS total_sales
 FROM
     `bigquery-public-data.thelook_ecommerce.order_items` AS order_items
 LEFT JOIN
     `bigquery-public-data.thelook_ecommerce.products` AS products
 ON
     order_items.product_id = products.id
 GROUP BY
     order_date,
     order_items.product_id,
     product_name
 ORDER BY
     total_sales DESC;

#Build a forecasting model and view results
CREATE MODEL bqml_tutorial.sales_forecasting_model
OPTIONS(MODEL_TYPE='ARIMA_PLUS',
time_series_timestamp_col='date_col',
time_series_data_col='total_sales',
time_series_id_col='product_id') AS
SELECT sum(sale_price) as total_sales,
DATE(created_at) as date_col,
product_id
FROM `bigquery-public-data.thelook_ecommerce.order_items`
AS t1
INNER JOIN `bigquery-public-data.thelook_ecommerce.products`
AS t2
ON t1.product_id = t2.id
GROUP BY 2, 3;

# Use sales_forecasting_model from the bqml_tutorial dataset in my project to generate a forecast and return all the resulting data.
 SELECT *
 FROM
   ML.FORECAST(MODEL `bqml_tutorial.sales_forecasting_model`);