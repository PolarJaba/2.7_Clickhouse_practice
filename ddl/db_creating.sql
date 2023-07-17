CREATE TABLE IF NOT EXISTS products (
    product_id Int32,
    product_name String NOT NULL,
    price Float64 NOT NULL,
    PRIMARY KEY product_id
)
ENGINE = MergeTree()
ORDER BY product_id;
CREATE TABLE IF NOT EXISTS plan (
    product_id Int32,
    shop_id Int32,
    plan_cnt Int32,
    plan_date Date
)
ENGINE = MergeTree()
ORDER BY product_id;
CREATE TABLE IF NOT EXISTS shops (
    shop_id Int32,
    shop_name String
)
ENGINE = MergeTree()
ORDER BY shop_id;
CREATE TABLE IF NOT EXISTS shop_dns (
    date Date,
    product_id Int32,
    sales_cnt Int32
)
ENGINE = MergeTree()
ORDER BY date;
CREATE TABLE IF NOT EXISTS shop_mvideo (
    date DATE,
    product_id Int32,
    sales_cnt Int32
)
ENGINE = MergeTree()
ORDER BY date;
CREATE TABLE IF NOT EXISTS shop_sitilink (
    date DATE,
    product_id Int32,
    sales_cnt Int32
)
ENGINE = MergeTree()
ORDER BY date;