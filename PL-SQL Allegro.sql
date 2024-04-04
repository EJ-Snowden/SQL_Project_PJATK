
-- The InsertNewProduct procedure inserts a new product into the Product table with the specified details.
-- It is looking for the greatest ID of Product and inserts a new product with MAX(ID) + 1.
-- Also it takes parameters such as product name, description, price, category ID, and seller user ID.

DROP PROCEDURE InsertNewProduct;
CREATE OR REPLACE PROCEDURE InsertNewProduct(
    p_ProductName VARCHAR2,
    p_Description VARCHAR2,
    p_Price NUMBER,
    p_CategoryID NUMBER,
    p_SellerUserID NUMBER
)
AS
    p_MaxProductID NUMBER;
BEGIN
    SELECT MAX(ID) INTO p_MaxProductID
    FROM Product;

    INSERT INTO Product (ID, Name, Description, Price, Category_ID, Seller_User_ID)
    VALUES (p_MaxProductID + 1, p_ProductName, p_Description, p_Price, p_CategoryID, p_SellerUserID);

    COMMIT;

    dbms_output.put_line('New product inserted with ID ' || TO_CHAR(p_MaxProductID + 1));
END;

SET SERVEROUTPUT ON;
CALL InsertNewProduct('Iphone 15','Powerful phone with advanced features',1299.99,1,3);

--The DisplayOrderProductInformation procedure fetches and displays information
-- about order products from the OrderProduct table.
-- It utilizes a cursor (cur) to iterate through the records in the table,
-- retrieving details such as Order Product ID, Order ID, Product ID, and Quantity.
-- The retrieved information is then printed to the console.

DROP PROCEDURE DisplayOrderProductInformation;
CREATE OR REPLACE PROCEDURE DisplayOrderProductInformation
AS
    CURSOR cur IS
        SELECT OrderProduct_ID, Order_ID, Product_ID, Quantity
        FROM OrderProduct;
    v_OrderProductID NUMBER;
    v_OrderID NUMBER;
    v_ProductID NUMBER;
    v_Quantity NUMBER;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO
            v_OrderProductID, v_OrderID, v_ProductID, v_Quantity;
        EXIT WHEN cur%NOTFOUND;
        dbms_output.put_line('Order Product ID: ' || v_OrderProductID);
        dbms_output.put_line('Order ID: ' || v_OrderID);
        dbms_output.put_line('Product ID: ' || v_ProductID);
        dbms_output.put_line('Quantity: ' || v_Quantity);
    END LOOP;
    CLOSE cur;
END;

SET SERVEROUTPUT ON;
CALL DisplayOrderProductInformation();


-- This trigger checks if there are any products associated with the seller before attempting to delete them.
-- If there are products, it proceeds to delete them; otherwise, it shows the following message.

DROP TRIGGER DeleteSellerProducts;
CREATE OR REPLACE TRIGGER DeleteSellerProducts
BEFORE DELETE ON Seller
FOR EACH ROW
DECLARE
    productCount INTEGER;
BEGIN
    SELECT COUNT(*) INTO productCount
    FROM Product
    WHERE Seller_User_ID = :OLD.User_ID;

    IF productCount > 0 THEN
        DELETE FROM Product
        WHERE Seller_User_ID = :OLD.User_ID;

        dbms_output.put_line('All Sellers products were deleted.');

    END IF;

        dbms_output.put_line('Wasnt found any Sellers products');
END;

SET SERVEROUTPUT ON;
DELETE FROM Seller WHERE User_ID = 1;

-- The trigger is designed to control the insertion and updating of records
-- in the Category table by enforcing specific rules related to the category name.

DROP TRIGGER UpdateCategoryName;
CREATE OR REPLACE TRIGGER UpdateCategoryName
BEFORE INSERT OR UPDATE ON Category
FOR EACH ROW
BEGIN
    IF INSERTING AND :NEW.Name = 'Restricted' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Category name cannot be set to "Restricted".');
    END IF;

    IF UPDATING AND :NEW.Name <> :OLD.Name AND EXISTS (SELECT 1 FROM Category WHERE Name = :NEW.Name) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Category name must be unique.');
    END IF;

    IF INSERTING AND :NEW.Name = (SELECT 1 FROM Category WHERE Name = :NEW.Name) THEN
        RAISE_APPLICATION_ERROR(-20102, 'Category already exists');
    END IF;
END;

SET SERVEROUTPUT ON;
INSERT INTO Category (Name) VALUES ('Restricted');