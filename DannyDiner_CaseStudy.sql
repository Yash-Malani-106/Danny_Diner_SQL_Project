-- DANNYS DINER CASE STUDY QUESTIONS
-------------------------------------------------------------------------
-- Q1: What is the total amount each customer spent at the restaurant?
SELECT 
    s.customer_id, 
    SUM(m.price) AS Total_Amount
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
------------------------------------------------------------------------------
-- Q2: How many days has each customer visited the restaurant?
SELECT 
    customer_id, COUNT(DISTINCT (order_date)) AS Number_of_Days
FROM
    sales
GROUP BY customer_id;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
------------------------------------------------------------------------------
-- Q3: What was the first item from the menu purchased by each customer?
select * from sales;
SELECT 
    s.customer_id, m.product_name
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
GROUP BY 1
ORDER BY s.order_date;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
------------------------------------------------------------------------------------------------------
-- Q4: What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    m.product_name, 
    COUNT(*) AS Purchase_Count
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
GROUP BY s.product_id
ORDER BY 2 DESC;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
------------------------------------------------------------------------------------------------------
-- Q5: Which item was the most popular for each customer?
SELECT 
	customer_id, 
    product_name AS popular_item 
FROM 
	(SELECT 
		s.customer_id, 
        m.product_name,
        RANK() OVER (PARTITION BY customer_id 
        ORDER BY count(*)) as count_product
		FROM 
			sales AS s 
				INNER JOIN  
			menu AS m ON s.product_id = m.product_id
			GROUP BY 1, s.product_id) temp 
WHERE temp.count_product = 1;
-- Solution by Yash Malani
---------------------------------------------------------------------------------
-- DANNYS DINER CASE STUDY QUESTIONS
------------------------------------------------------------------------------------------------------
-- Q6: Which item was purchased first by the customer after they became a member?
SELECT 
    s.customer_id,
    m.product_name
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
        INNER JOIN
    members AS mem ON s.customer_id = mem.customer_id
WHERE
    s.order_date >= mem.join_date
GROUP BY 1
ORDER BY s.order_date;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
---------------------------------------------------------------------------------------
-- Q7: Which item was purchased just before the customer became a member?
SELECT 
    s.customer_id, 
    m.product_name
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
        INNER JOIN
    members AS mem ON s.customer_id = mem.customer_id
WHERE
    s.order_date < mem.join_date
GROUP BY 1
ORDER BY s.order_date;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
-------------------------------------------------------------------------------------------
-- Q8: What is the total items and amount spent for each member before they became a member?
SELECT 
    s.customer_id, 
    Count(m.product_name) AS Total_Items,
    SUM(m.price) AS Amount_Before_Membership
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
        INNER JOIN
    members AS mem ON s.customer_id = mem.customer_id
WHERE
    s.order_date < mem.join_date
GROUP BY 1
ORDER BY s.order_date;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
-----------------------------------------------------------------------------------------------------------------------------
-- Q9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT 
    s.customer_id,
    SUM(CASE
        WHEN m.product_name LIKE 'sushi' THEN m.price * 20
        ELSE m.price * 10
    END) AS points
FROM
    sales AS s
        INNER JOIN
    menu AS m ON s.product_id = m.product_id
GROUP BY 1;
-- Solution by Yash Malani
-- DANNYS DINER CASE STUDY QUESTIONS
-----------------------------------------------------------------------------------------------------------------------------
-- Q10: In the first week after a customer joins the program (including their join date) they earn 20 points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?
 WITH first_week_membership AS (SELECT s.customer_id, 
									 s.order_date, 
								     CASE 
										WHEN (s.order_date >= mem.join_date) AND (s.order_date <= date(mem.join_date + 7))
											THEN m.price * 20
										WHEN m.product_name = 'sushi' 
											THEN m.price * 20 
											ELSE m.price * 10 
										END price
									 FROM 
										sales AS s 
											INNER JOIN 
										menu AS m ON s.product_id = m.product_id 
											LEFT JOIN
										members AS mem ON s.customer_id = mem.customer_id)
SELECT 
	customer_id, 
	SUM(price) AS points 
FROM 
	first_week_membership 
WHERE order_date BETWEEN '2021-01-01' AND '2021-02-01' 
GROUP BY s.customer_id 
ORDER BY points DESC;





