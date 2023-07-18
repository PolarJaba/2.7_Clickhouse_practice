WITH
	sales_all AS (
		SELECT product_id, date, sales_cnt,
		       (SELECT shop_id FROM shops WHERE shop_name = 'DNS') AS shop_id
		FROM shop_dns
		UNION DISTINCT SELECT product_id, date, sales_cnt,
			  	      (SELECT shop_id FROM shops WHERE shop_name = 'MVideo') AS shop_id
			       FROM shop_mvideo
		UNION DISTINCT SELECT product_id, date, sales_cnt,
				      (SELECT shop_id FROM shops WHERE shop_name = 'Sitilink') AS shop_id
			       FROM shop_sitilink),
	sales AS (
		SELECT sold.shop_id, sold.product_id, SUM(sold.sales_cnt) AS sales_fact, sales_plan
		FROM (SELECT sa.shop_id, sa.product_id, sa.sales_cnt, date, pl.plan_date AS pl_date, pl.plan_cnt AS sales_plan
		     FROM sales_all sa
		     INNER JOIN plan pl ON sa.shop_id = pl.shop_id AND sa.product_id = pl.product_id
		) AS sold
		WHERE date BETWEEN date_trunc('month', pl_date) AND pl_date 
		GROUP BY shop_id, product_id, sales_plan
		ORDER BY shop_id, product_id
	)
SELECT sh.shop_name, pr.product_name, sales_fact,
	   sold.sales_plan, sold.sales_fact/sold.sales_plan AS "sales_fact/sales_plan",
	   sold.sales_fact * pr.price AS income_fact,
	   sold.sales_plan * pr.price AS income_plan,
	   (sold.sales_fact * pr.price)/(sold.sales_plan * pr.price) AS "income_fact/income_plan"
FROM sales AS sold
INNER JOIN shops AS sh ON sold.shop_id = sh.shop_id
INNER JOIN products AS pr ON sold.product_id = pr.product_id
ORDER BY shop_name, product_name;