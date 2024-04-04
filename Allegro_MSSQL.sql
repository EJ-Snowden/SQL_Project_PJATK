ALTER TABLE Buyer DROP CONSTRAINT Buyer_Address;

ALTER TABLE Buyer DROP CONSTRAINT Buyer_User;

ALTER TABLE OrderProduct DROP CONSTRAINT OrderProduct_Order;

ALTER TABLE OrderProduct DROP CONSTRAINT OrderProduct_Product;

ALTER TABLE "Order" DROP CONSTRAINT Order_Buyer;

ALTER TABLE Product DROP CONSTRAINT Product_Category;

ALTER TABLE Product DROP CONSTRAINT Product_Seller;

ALTER TABLE Review DROP CONSTRAINT Review_Order;

ALTER TABLE Seller DROP CONSTRAINT Seller_User;

DROP TABLE Address;

DROP TABLE Buyer;

DROP TABLE Category;

DROP TABLE "Order";

DROP TABLE OrderProduct;

DROP TABLE Product;

DROP TABLE Review;

DROP TABLE Seller;

DROP TABLE "User";

CREATE TABLE Address (
    ID int  NOT NULL,
    Street varchar(30)  NOT NULL,
    House_number int  NOT NULL,
    Post_code int  NOT NULL,
    Flat_number int  NULL,
    CONSTRAINT Address_pk PRIMARY KEY  (ID)
);

INSERT INTO Address (ID, Street, House_number, Post_code, Flat_number)
VALUES (1, 'Main Street', 123, 12345, 4);
INSERT INTO Address (ID, Street, House_number, Post_code, Flat_number)
VALUES (2, 'Oak Avenue', 456, 54321, 8);
INSERT INTO Address (ID, Street, House_number, Post_code, Flat_number)
VALUES (3, 'Maple Lane', 789, 98765, NULL);
INSERT INTO Address (ID, Street, House_number, Post_code, Flat_number)
VALUES (4, 'Pine Street', 567, 56789, 12);

CREATE TABLE Buyer (
    User_ID int  NOT NULL,
    Address_ID int  NOT NULL,
    CONSTRAINT Buyer_pk PRIMARY KEY  (User_ID)
);

INSERT INTO Buyer (User_ID, Address_ID)
VALUES (1, 1);
INSERT INTO Buyer (User_ID, Address_ID)
VALUES (2, 2);
INSERT INTO Buyer (User_ID, Address_ID)
VALUES (3, 3);
INSERT INTO Buyer (User_ID, Address_ID)
VALUES (4, 4);

CREATE TABLE Category (
    ID int  NOT NULL,
    Name varchar(20)  NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY  (ID)
);

INSERT INTO Category (ID, Name)
VALUES (1, 'Electronics');
INSERT INTO Category (ID, Name)
VALUES (2, 'Clothing');
INSERT INTO Category (ID, Name)
VALUES (3, 'Home and Kitchen');
INSERT INTO Category (ID, Name)
VALUES (4, 'Sports and Outdoors');

CREATE TABLE "Order" (
    ID int  NOT NULL,
    Buyer_User_ID int  NOT NULL,
    order_date date  NOT NULL,
    CONSTRAINT Order_pk PRIMARY KEY  (ID)
);

INSERT INTO "Order" (ID, Buyer_User_ID, order_date)
VALUES (1, 1, '2023-11-30');
INSERT INTO "Order" (ID, Buyer_User_ID, order_date)
VALUES (2, 2, '2023-12-01');
INSERT INTO "Order" (ID, Buyer_User_ID, order_date)
VALUES (3, 3, '2023-12-02');
INSERT INTO "Order" (ID, Buyer_User_ID, order_date)
VALUES (4, 4, '2023-12-03');

CREATE TABLE OrderProduct (
    OrderProduct_ID int  NOT NULL,
    Order_ID int  NOT NULL,
    Product_ID int  NOT NULL,
    Quantity int  NOT NULL,
    CONSTRAINT OrderProduct_pk PRIMARY KEY  (OrderProduct_ID)
);

INSERT INTO OrderProduct (OrderProduct_ID, Order_ID, Product_ID, Quantity)
VALUES (1, 1, 1, 2);
INSERT INTO OrderProduct (OrderProduct_ID, Order_ID, Product_ID, Quantity)
VALUES (2, 2, 1, 3);
INSERT INTO OrderProduct (OrderProduct_ID, Order_ID, Product_ID, Quantity)
VALUES (3, 3, 2, 1);
INSERT INTO OrderProduct (OrderProduct_ID, Order_ID, Product_ID, Quantity)
VALUES (4, 4, 3, 2);

CREATE TABLE Product (
    ID int  NOT NULL,
    Name varchar(40)  NOT NULL,
    Description varchar(300)  NOT NULL,
    Price decimal(6,2)  NOT NULL,
    Seller_User_ID int  NOT NULL,
    Category_ID int  NOT NULL,
    CONSTRAINT Product_pk PRIMARY KEY  (ID)
);

INSERT INTO Product (ID, Name, Description, Price, Seller_User_ID, Category_ID)
VALUES (1, 'Laptop', 'Powerful laptop with high performance', 999.99, 2, 1);
INSERT INTO Product (ID, Name, Description, Price, Seller_User_ID, Category_ID)
VALUES (2, 'T-Shirt', 'Comfortable cotton T-shirt', 19.99, 1, 2);
INSERT INTO Product (ID, Name, Description, Price, Seller_User_ID, Category_ID)
VALUES (3, 'Coffee Maker', 'Automatic drip coffee maker', 49.99, 3, 3);
INSERT INTO Product (ID, Name, Description, Price, Seller_User_ID, Category_ID)
VALUES (4, 'Running Shoes', 'Comfortable running shoes for all terrains', 79.99, 4, 4);

CREATE TABLE Review (
    ID int  NOT NULL,
    Text varchar(200)  NOT NULL,
    Order_ID int  NOT NULL,
    Rating int  NOT NULL,
    CONSTRAINT Review_pk PRIMARY KEY  (ID)
);

INSERT INTO Review (ID, Text, Order_ID, Rating)
VALUES (1, 'Great product!', 1, 5);
INSERT INTO Review (ID, Text, Order_ID, Rating)
VALUES (2, 'Satisfied with the purchase', 2, 4);
INSERT INTO Review (ID, Text, Order_ID, Rating)
VALUES (3, 'Easy to use and makes great coffee', 3, 5);
INSERT INTO Review (ID, Text, Order_ID, Rating)
VALUES (4, 'Excellent shoes for jogging', 4, 5);

CREATE TABLE Seller (
    User_ID int  NOT NULL,
    CONSTRAINT Seller_pk PRIMARY KEY  (User_ID)
);

INSERT INTO Seller (User_ID)
VALUES (2);
INSERT INTO Seller (User_ID)
VALUES (1);
INSERT INTO Seller (User_ID)
VALUES (4);
INSERT INTO Seller (User_ID)
VALUES (3);

CREATE TABLE "User" (
    ID int  NOT NULL,
    Name varchar(20)  NOT NULL,
    Surname varchar(20)  NOT NULL,
    CONSTRAINT User_pk PRIMARY KEY  (ID)
);

INSERT INTO "User" (ID, Name, Surname)
VALUES (1, 'John', 'Doe');
INSERT INTO "User" (ID, Name, Surname)
VALUES (2, 'Jane', 'Smith');
INSERT INTO "User" (ID, Name, Surname)
VALUES (3, 'Robert', 'Johnson');
INSERT INTO "User" (ID, Name, Surname)
VALUES (4, 'Sarah', 'Miller');

ALTER TABLE Buyer ADD CONSTRAINT Buyer_Address
    FOREIGN KEY (Address_ID)
    REFERENCES Address (ID);

ALTER TABLE Buyer ADD CONSTRAINT Buyer_User
    FOREIGN KEY (User_ID)
    REFERENCES "User" (ID);

ALTER TABLE OrderProduct ADD CONSTRAINT OrderProduct_Order
    FOREIGN KEY (Order_ID)
    REFERENCES "Order" (ID);

ALTER TABLE OrderProduct ADD CONSTRAINT OrderProduct_Product
    FOREIGN KEY (Product_ID)
    REFERENCES Product (ID);

ALTER TABLE "Order" ADD CONSTRAINT Order_Buyer
    FOREIGN KEY (Buyer_User_ID)
    REFERENCES Buyer (User_ID);

ALTER TABLE Product ADD CONSTRAINT Product_Category
    FOREIGN KEY (Category_ID)
    REFERENCES Category (ID);

ALTER TABLE Product ADD CONSTRAINT Product_Seller
    FOREIGN KEY (Seller_User_ID)
    REFERENCES Seller (User_ID);

ALTER TABLE Review ADD CONSTRAINT Review_Order
    FOREIGN KEY (Order_ID)
    REFERENCES "Order" (ID);

ALTER TABLE Seller ADD CONSTRAINT Seller_User
    FOREIGN KEY (User_ID)
    REFERENCES "User" (ID);