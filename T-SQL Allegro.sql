
-- This procedure calculates the total revenue generated by a specific seller by
-- Accepting the seller's user ID as a parameter.
-- Summing up the total revenue generated by all products sold by the seller.
-- Returning the total revenue amount.

DROP PROCEDURE CalculateSellerRevenue;
CREATE PROCEDURE CalculateSellerRevenue
    @sellerUserId INT,
    @totalRevenue DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @totalRevenue = SUM(p.Price * op.Quantity)
    FROM Product p
    JOIN OrderProduct op ON p.ID = op.Product_ID
    JOIN "Order" o ON op.Order_ID = o.ID
    WHERE p.Seller_User_ID = @sellerUserId;

    PRINT @totalRevenue;
END;

DECLARE @outputRevenue DECIMAL(10,2);
EXEC CalculateSellerRevenue @sellerUserId = 123, @totalRevenue = @outputRevenue OUTPUT;
PRINT 'Total Revenue: ' + CAST(@outputRevenue AS NVARCHAR(20));

--This procedure uses a cursor to iterate through orders and, for each order,
-- uses another cursor to iterate through the products associated with that order.
-- The information is then printed to the console,
-- providing a detailed view of orders along with their respective products.

DROP PROCEDURE GetOrderDetailsWithProducts;
CREATE PROCEDURE GetOrderDetailsWithProducts
AS
BEGIN
    DECLARE @orderId INT;
    DECLARE @orderDate DATE;
    DECLARE @buyerId INT;
    DECLARE @buyerName VARCHAR(20);
    DECLARE @buyerSurname VARCHAR(20);
    DECLARE @productId INT;
    DECLARE @productName VARCHAR(40);
    DECLARE @productPrice DECIMAL(6,2);
    DECLARE @quantity INT;

    DECLARE orderCursor CURSOR FOR
    SELECT o.ID AS OrderID, o.order_date AS OrderDate,
           b.User_ID AS BuyerID, u.Name AS BuyerName, u.Surname AS BuyerSurname
    FROM "Order" o
    JOIN Buyer b ON o.Buyer_User_ID = b.User_ID
    JOIN "User" u ON b.User_ID = u.ID;

    OPEN orderCursor;

    FETCH NEXT FROM orderCursor INTO @orderId, @orderDate, @buyerId, @buyerName, @buyerSurname;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'OrderID: ' + CONVERT(VARCHAR, @orderId);
        PRINT 'OrderDate: ' + CONVERT(VARCHAR, @orderDate);
        PRINT 'BuyerID: ' + CONVERT(VARCHAR, @buyerId);
        PRINT 'BuyerName: ' + @buyerName;
        PRINT 'BuyerSurname: ' + @buyerSurname;

        DECLARE productCursor CURSOR FOR
        SELECT p.ID AS ProductID, p.Name AS ProductName, p.Price AS ProductPrice, op.Quantity
        FROM OrderProduct op
        JOIN Product p ON op.Product_ID = p.ID
        WHERE op.Order_ID = @orderId;

        OPEN productCursor;

        FETCH NEXT FROM productCursor INTO @productId, @productName, @productPrice, @quantity;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT '   ProductID: ' + CONVERT(VARCHAR, @productId);
            PRINT '   ProductName: ' + @productName;
            PRINT '   ProductPrice: ' + CONVERT(VARCHAR, @productPrice);
            PRINT '   Quantity: ' + CONVERT(VARCHAR, @quantity);
            PRINT '';

            FETCH NEXT FROM productCursor INTO @productId, @productName, @productPrice, @quantity;
        END

        CLOSE productCursor;
        DEALLOCATE productCursor;

        FETCH NEXT FROM orderCursor INTO @orderId, @orderDate, @buyerId, @buyerName, @buyerSurname;
    END

    CLOSE orderCursor;
    DEALLOCATE orderCursor;
END;

EXEC GetOrderDetailsWithProducts;

-- The trigger is designed to prevent the insertion of duplicate entries into the OrderProduct table
-- based on the combination of Order_ID and Product_ID.
-- It retrieves values from the inserted table, which holds the rows being inserted.
-- Checks if a duplicate entry exists using IF EXISTS.
-- If a duplicate is found, it raises an error using the THROW statement.
-- If no duplicate is found, it calculates the maximum OrderProduct_ID in the table.
-- Inserts a new row with an OrderProduct_ID incremented by 1.

DROP TRIGGER PreventDuplicateOrderProduct;
CREATE TRIGGER PreventDuplicateOrderProduct
ON OrderProduct
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @orderId INT;
    DECLARE @productId INT;
    DECLARE @maxOrderProductID INT;

    SELECT @orderId = Order_ID, @productId = Product_ID
    FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM OrderProduct
        WHERE Order_ID = @orderId AND Product_ID = @productId
    )
    BEGIN
        THROW 51000, 'Duplicate entry for the same product in the order.', 1;
    END
    ELSE
    BEGIN
        SELECT @maxOrderProductID = MAX(OrderProduct_ID)
        FROM OrderProduct;

        INSERT INTO OrderProduct (OrderProduct_ID, Order_ID, Product_ID, Quantity)
        SELECT @maxOrderProductID + 1, Order_ID, Product_ID, Quantity
        FROM inserted;
    END
END;

INSERT INTO OrderProduct (OrderProduct_ID, Order_ID, Product_ID, Quantity)
VALUES (1, 1, 1, 2);

-- The trigger is designed to update the order_date in the corresponding Order table
-- based on the operation type (INSERT, UPDATE, or DELETE) on the OrderProduct table.
-- It updates the order_date in the Order table for the identified Order_ID to the current date using GETDATE().

DROP TRIGGER UpdateOrderDate;
CREATE TRIGGER UpdateOrderDate
ON OrderProduct
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @orderId INT;

    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @orderId = Order_ID
        FROM inserted;
    END
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @orderId = Order_ID
        FROM deleted;
    END
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @orderId = Order_ID
        FROM deleted;
    END

    UPDATE "Order"
    SET order_date = GETDATE()
    WHERE ID = @orderId;

    PRINT 'Order date was updated.'
END;

UPDATE OrderProduct
SET Quantity = 3
WHERE Order_ID = 1 AND Product_ID = 1;