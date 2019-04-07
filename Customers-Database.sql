USE master;
CREATE DATABASE Customers CONTAINMENT = NONE
ON PRIMARY
(   NAME = N'Customers_Data',
    FILENAME = N'C:\SQLData\Customers.mdf',
    SIZE = 210176KB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 16384KB
)
LOG ON
(   NAME = N'Customers_Log',
    FILENAME = N'C:\SQLData\Customers.ldf',
    SIZE = 2048KB,
    MAXSIZE = 2048GB,
    FILEGROWTH = 16384KB
);
GO

USE Customers;
GO
--only create the Customer schema if it does not exist
IF EXISTS (SELECT * FROM sys.schemas WHERE schemas.name LIKE 'Customer')
SET NOEXEC ON;
GO
CREATE SCHEMA Customer;
GO --
SET NOEXEC OFF;
--delete the table with all the foreign key references in it
IF EXISTS (
  SELECT * FROM sys.objects
    WHERE objects.object_id LIKE OBJECT_ID('Customer.Abode')
   )
   DROP TABLE Customer.Abode;
IF EXISTS (SELECT *
             FROM sys.objects
             WHERE objects.object_id LIKE OBJECT_ID('Customer.Phone')
   )
   DROP TABLE Customer.Phone;
GO
IF EXISTS (
  SELECT *      FROM sys.objects
    WHERE objects.object_id LIKE OBJECT_ID('Customer.Person')
   )
    DROP TABLE Customer.Person;
GO
CREATE TABLE Customer.Person
  (
    person_ID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(8) NULL,
    FirstName VARCHAR(40) NOT NULL,
    MiddleName VARCHAR(40) NULL,
    LastName VARCHAR(40) NOT NULL,
    Suffix NVARCHAR(10) NULL,
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);


IF EXISTS (SELECT *
             FROM sys.objects
             WHERE objects.object_id LIKE OBJECT_ID('Customer.Address')
   )
   DROP TABLE Customer.Address;
GO
CREATE TABLE Customer.Address
  (
    AddressID INT IDENTITY PRIMARY KEY,
    AddressLine1 NVARCHAR(60) NOT NULL,
    AddressLine2 NVARCHAR(60) NULL,
    City NVARCHAR(30) NOT NULL,
    County NVARCHAR(30) NOT NULL,
    PostCode NVARCHAR(15) NOT NULL,
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO
IF EXISTS (SELECT *
             FROM sys.objects
             WHERE objects.object_id LIKE OBJECT_ID('Customer.AddressType')
   )
   DROP TABLE Customer.AddressType;
GO
CREATE TABLE Customer.AddressType
  (
    TypeOfAddress VARCHAR(40) PRIMARY key,
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
   );
   GO
IF EXISTS (SELECT *
             FROM sys.objects
             WHERE objects.object_id LIKE OBJECT_ID('Customer.Abode')
   )
   DROP TABLE Customer.Abode;
GO
CREATE TABLE Customer.Abode
  (
    Abode_ID INT IDENTITY PRIMARY KEY,
    Person_id INT FOREIGN KEY REFERENCES Customer.Person,
    Address_id INT FOREIGN KEY REFERENCES  Customer.Address,
	TypeOfAddress VARCHAR(40) FOREIGN KEY REFERENCES Customer.AddressType,
    Start_date DATETIME,
    End_date DATETIME,
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);

IF EXISTS (SELECT *
             FROM sys.objects
             WHERE objects.object_id LIKE OBJECT_ID('Customer.PhoneType')
   )
   DROP TABLE Customer.PhoneType;
GO
CREATE TABLE Customer.PhoneType
  (
   TypeOfPhone VARCHAR(40) PRIMARY key,
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Customer.Phone
  (
    Phone_ID INT IDENTITY PRIMARY KEY,
    Person_id INT FOREIGN KEY REFERENCES Customer.Person,
    TypeOfPhone VARCHAR(40) FOREIGN KEY REFERENCES  Customer.Phonetype,
	DiallingNumber VARCHAR(20),
    Start_date DATETIME,
    End_date DATETIME,
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);

IF EXISTS (SELECT *
             FROM sys.objects
             WHERE objects.object_id LIKE OBJECT_ID('Customer.Note')
   )
   DROP TABLE Customer.Note;
GO
CREATE TABLE Customer.Note
  (
	Note_id VARCHAR(40) PRIMARY key,
	Note VARCHAR(8000),
	InsertionDate  DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);


EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Primary key for Address records.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address', @level2type = N'COLUMN',
  @level2name = N'AddressID';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'First street address line.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address', @level2type = N'COLUMN',
  @level2name = N'AddressLine1';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Second street address line.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address', @level2type = N'COLUMN',
  @level2name = N'AddressLine2';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Name of the city.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'City';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Postal code for the street address.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address', @level2type = N'COLUMN',
  @level2name = N'PostCode';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Date and time the record was last updated.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address', @level2type = N'COLUMN',
  @level2name = N'ModifiedDate';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Street address information for Customers, employees, and vendors.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Address';
GO


EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Primary key for Person records.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'Person',
  @level2type = N'COLUMN', @level2name = N'Person_ID';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'A courtesy title. For example, Mr. or Ms.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Person', @level2type = N'COLUMN', @level2name = N'Title';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'First name of the person.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'Person',
  @level2type = N'COLUMN', @level2name = N'FirstName';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Middle name or middle initial of the person.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Person', @level2type = N'COLUMN',
  @level2name = N'MiddleName';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Last name of the person.', @level0type = N'SCHEMA',
  @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'Person',
  @level2type = N'COLUMN', @level2name = N'LastName';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Surname suffix. For example, Sr. or Jr.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Person', @level2type = N'COLUMN', @level2name = N'Suffix';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'Date and time the record was last updated.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Person', @level2type = N'COLUMN',
  @level2name = N'ModifiedDate';
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
  @value = N'People involved with the Widget Manufacturing Co.',
  @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE',
  @level1name = N'Person';
GO