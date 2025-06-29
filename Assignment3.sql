1. Retrieve the list of all dishes along with their restaurant names and prices.
Select Dishes.DishID, Dishes.Name, Dishes.Price, Restaurants.Name as restaurant_name
From Dishes
Join Restaurants on
Dishes.RestaurantID = Restaurants.RestaurantID;


2. Find the average rating of all restaurants in New York.
Select City ,
Avg(Rating) as avg_rating
From Restaurants
where city = 'New York'
Group by City;


3. Calculate the total revenue generated by each restaurant.
 Select Restaurants.RestaurantID, Restaurants.Name, Sum(TotalAmount) as revenue
From Orders
Join Restaurants on
Orders.RestaurantID = Restaurants.RestaurantID
Group by Restaurants.RestaurantID ,Restaurants.Name;

4. List the names of customers who have ordered more than once.
Select Customers.Name, count(Orders.OrderID) as count_value
From Orders
Join Customers on Orders.CustomerID = Customers.CustomerID
Group by Customers.Name
HAVING COUNT(Orders.OrderID) > 1;

5. Use a window function to rank restaurants based on their average customer ratings.
SELECT Restaurants.RestaurantID, Restaurants.Name,
Avg(Restaurants.Rating) as avergae_customer_rating,
Rank() Over(Order by Avg(Restaurants.Rating) Desc) As RatingRank
From Restaurants
Join Orders on
Restaurants.RestaurantID = Orders.RestaurantID
Join Reviews on
Orders.OrderID = Reviews.OrderID
GROUP by Restaurants.RestaurantID , Restaurants.Name;


6. Calculate the cumulative total revenue for each restaurant.
Select Orders.OrderID, Orders.RestaurantID, Orders.OrderDate,Orders.TotalAmount,
Restaurants.Name as restaurant_name
,Sum(Orders.TotalAmount)
Over(Partition by Orders.RestaurantID Order by Orders.OrderDate Rows BETWEEN UNBOUNDED PRECEDING AND
CURRENT Row) as CumulativeRevenue
From Orders
Join Restaurants on
Orders.RestaurantID = Restaurants.RestaurantID
Order by Orders.RestaurantID, Orders.OrderDate;


8. Find the average delivery time for each delivery person and rank them.
WITH AvgDelivery AS (
SELECT
DeliveryPerson,
AVG(DeliveryTime) AS AvgTime
FROM Deliveries
GROUP BY DeliveryPerson
),
RankedDelivery AS (
SELECT
DeliveryPerson,
AvgTime,
RANK() OVER (ORDER BY AvgTime ASC) AS `Rank`
FROM AvgDelivery
)
SELECT *
FROM RankedDelivery
ORDER BY `Rank`;


9. Retrieve the count of orders placed in each city.

Select customers.city , count(Orders.OrderID) as Order_count
From Orders
Join customers on Orders.customerid = customers.customerid
group by customers.city
order by Order_count desc;

10. Calculate the average order value for each cuisine type.

Select Restaurants.Cuisine ,
Avg(Orders.TotalAmount) as average_order_value
From orders
Join Restaurants on
Orders.RestaurantID = Restaurants.RestaurantID
Group by Restaurants.Cuisine
Order by average_order_value desc;


11. List all reviews with a rating below 4.
Select * from reviews
where rating < 4;

12. Display all orders placed after October 1, 2023.
Select * from Orders
where OrderDate > '2023-10-01';

13. Write a query to display order details along with the restaurant and customer names
Select Orders.OrderID, Customers.Name as customer_name , Restaurants.Name as restaurant_name , Orders.OrderDate, Orders.TotalAmount
From Orders
Join Customers ON Orders.CustomerID = Customers.CustomerID
JOIN Restaurants ON Orders.RestaurantID = Restaurants.RestaurantID
Order by Orders.OrderID;

14. Show all dishes ordered by each customer.

Select
Customers.name as customer_name,
Dishes.Name as dish_name ,
OrderDetails.Quantity
From Orders
Join Customers ON Orders.CustomerID = Customers.CustomerID
JOin OrderDetails ON Orders.OrderID = OrderDetails.OrderID
Join Dishes ON OrderDetails.DishID = Dishes.DishID
Order By Customers.Name, Dishes.Name;


15. Find the name of the customer who gave the lowest rating.
Select
Customers.Name as cutomer_name
,
Reviews.Rating
From Reviews
Join Customers on
Reviews.CustomerID = Customers.CustomerID
where Reviews.Rating = (Select Min(Rating) from Reviews);


16. Retrieve the most expensive dish for each cuisine type.
Select Restaurants.Cuisine , Dishes.Name, Dishes.Price
From Dishes
Join Restaurants on
Dishes.RestaurantID = Restaurants.RestaurantID
where Dishes.Price = ( Select Max(Dishes.Price) From Dishes Join Restaurants on Dishes.RestaurantID = Restaurants.RestaurantID
Where Restaurants.Cuisine = Restaurants.Cuisine
) Order by Restaurants.Cuisine;

17. Identify the delivery person with the fastest average delivery time.
Select DeliveryPerson, Average_time
From (
Select DeliveryPerson, Avg(DeliveryTime) as Average_time
From Deliveries
Group by DeliveryPerson
) as Avg_table
Order by Average_time Asc
Limit 1;


18. Calculate the average delivery time for all orders handled by "Carlos Gonzalez."
Select DeliveryPerson, Avg(DeliveryTime) as Average_time
FROM Deliveries
WHERE DeliveryPerson = 'Carlos Gonzalez'
GROUP BY DeliveryPerson;


19. Use a window function to assign a rank to each review based on its date, grouped by customer.

SELECT
ReviewID,
CustomerID,
Rating,
ReviewDate,
RANK() OVER (PARTITION BY CustomerID ORDER BY ReviewDate DESC) AS Review_rank
FROM Reviews
ORDER BY CustomerID, Review_rank;

20. Calculate the running total of revenue for orders by each customer.
Select
OrderID, CustomerID, OrderDate, TotalAmount, Sum(TotalAmount) Over(Partition by CustomerID Order by OrderDate) as Running_total
From Orders
Order by CustomerID, OrderDate;