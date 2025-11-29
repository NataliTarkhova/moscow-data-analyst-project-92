-- Отчет 1: Топ-10 продавцов по суммарной выручке (income) и количеству операций (operations)

SELECT
    CONCAT(TRIM(e.first_name), ' ', TRIM(e.last_name)) AS seller,
    COUNT(s.sales_id) AS operations,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM sales s
JOIN employees e ON e.employee_id = s.sales_person_id
JOIN products p ON p.product_id = s.product_id
GROUP BY seller
ORDER BY income DESC
LIMIT 10;

-- Отчет 2: Продавцы, у которых средняя выручка за сделку ниже средней среди всех продавцов

WITH seller_avg AS (
    SELECT
        CONCAT(TRIM(e.first_name), ' ', TRIM(e.last_name)) AS seller,
        AVG(p.price * s.quantity) AS avg_income
    FROM sales s
    JOIN employees e ON e.employee_id = s.sales_person_id
    JOIN products p ON p.product_id = s.product_id
    GROUP BY seller
),
total_avg AS (
    SELECT AVG(avg_income) AS global_avg
    FROM seller_avg
)
SELECT
    seller,
    FLOOR(avg_income) AS average_income
FROM seller_avg, total_avg
WHERE seller_avg.avg_income < total_avg.global_avg
ORDER BY average_income ASC;

-- Отчет 3: Выручка по дням недели для каждого продавца

SELECT
    CONCAT(TRIM(e.first_name), ' ', TRIM(e.last_name)) AS seller,
    TRIM(LOWER(TO_CHAR(s.sale_date, 'day'))) AS day_of_week,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM sales s
JOIN employees e ON e.employee_id = s.sales_person_id
JOIN products p ON p.product_id = s.product_id
GROUP BY seller, day_of_week
ORDER BY
    EXTRACT(DOW FROM s.sale_date),
    seller;

