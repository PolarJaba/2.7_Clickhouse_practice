WITH
    -- Создание общей таблицы всех продаж всех магазинов
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
	-- Подсчет проданных единиц товара в каждом магазине
    sales AS (
		SELECT sold.shop_id, sold.product_id, SUM(sold.sales_cnt) AS sales_fact
		FROM (SELECT sa.shop_id, sa.product_id, sa.sales_cnt, date, pl.plan_date AS pl_date
		     FROM sales_all sa
		     INNER JOIN plan pl ON sa.shop_id = pl.shop_id AND sa.product_id = pl.product_id
		) AS sold
        -- Фильтрация по конкретному месяцу продаж
		WHERE date BETWEEN date_trunc('month', pl_date) AND pl_date 
		GROUP BY shop_id, product_id
		ORDER BY shop_id, product_id
	)
SELECT sh.shop_name, pr.product_name, sales_fact,
	   pl.plan_cnt AS sales_plan, sold.sales_fact/pl.plan_cnt AS "sales_fact/sales_plan",
	   sold.sales_fact * pr.price AS income_fact,
	   pl.plan_cnt * pr.price AS income_plan,
	   (sold.sales_fact * pr.price)/(pl.plan_cnt * pr.price) AS "income_fact/income_plan"
FROM plan AS pl
INNER JOIN shops AS sh ON pl.shop_id = sh.shop_id
INNER JOIN sales AS sold ON pl.shop_id = sold.shop_id AND pl.product_id = sold.product_id
INNER JOIN products AS pr ON pl.product_id = pr.product_id
ORDER BY shop_name;