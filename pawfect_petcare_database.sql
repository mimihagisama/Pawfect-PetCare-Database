CREATE DATABASE Pawfect_Pet_Care;

USE Pawfect_Pet_Care;

/* Pawfect Care is a veterinary clinic that provides medical services for pets (consultations, 
grooming, vaccinations, surgeries) and also runs a pet store that sells food, accessories, 
and medications. Pawfect Pet Care want to build a centralized relational database that captures both the clinical and 
retail aspects of their business. This database will serve as the foundation for future digital 
tools like appointment apps and inventory dashboards. */

--Creating Tables

--Creating Store Tables

CREATE TABLE Stores( 
    Store_ID INT PRIMARY KEY IDENTITY(1,1),
    Store_Name NVARCHAR(100) NOT NULL,
    Store_Address NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(15) NOT NULL,
    Store_Manager NVARCHAR(100) NOT NULL
);
SELECT * FROM Stores;

-- Creating Pet Owners Table
CREATE TABLE Pet_Owners(
    Owner_ID INT PRIMARY KEY IDENTITY(1,1),
    Owner_Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(15) NOT NULL,
    Address NVARCHAR(255) NOT NULL
);

-- Creating Pets Table
CREATE TABLE Pets(
    Pet_ID INT PRIMARY KEY IDENTITY(1,1),
    Owner_ID INT,
    Pet_Name NVARCHAR(100) NOT NULL,
    Species NVARCHAR(50) NOT NULL,
    Breed NVARCHAR(100),
    Gender NVARCHAR(10),
    Age INT,
    Weight DECIMAL(5,2)
);

--Creating Pet Conditions Table
CREATE TABLE Pet_Conditions(
    Condition_ID INT PRIMARY KEY IDENTITY(1,1),
    Pet_ID INT,
    Condition_Name NVARCHAR(100) NOT NULL,
    Diagnosis_Date DATE,
    Severity NVARCHAR(50) CHECK (Severity IN ('Mild', 'Moderate', 'Severe','Critical')),
);

--Creating Pet Treatments Table
CREATE TABLE Pet_Treatments(
    Treatment_ID INT PRIMARY KEY IDENTITY(1,1),
    Pet_ID INT,
    Treatment_Name NVARCHAR(100) NOT NULL,
    Treatment_Description NVARCHAR(255) NOT NULL,
    Start_Date DATE,
    End_Date DATE,
    Frequency NVARCHAR(50),
    Veterinarian NVARCHAR(100),
    Notes NVARCHAR(255)
);

--Creating Staff Table
CREATE TABLE Staff(
    Staff_ID INT PRIMARY KEY IDENTITY(1,1),
    Store_ID INT,
    Staff_Name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) CHECK (Role IN ('Veterinarian', 'Vet Assistant', 'Groomer', 'Store Clerk', 'Manager')),
    Specialty NVARCHAR(100),
    Staff_Email NVARCHAR(100) UNIQUE NOT NULL,
    Staff_Phone NVARCHAR(15) NOT NULL,
    Hire_Date DATE,
    Salary DECIMAL(10,2)
);

--Creating Staff Availability Table
CREATE TABLE Staff_Availability(
    Availability_ID INT PRIMARY KEY IDENTITY(1,1),
    Staff_ID INT,
    Available_Date DATE,
    Start_Time TIME,
    End_Time TIME,
    Is_Available BIT
);

--Creating Packages Table
CREATE TABLE Packages(
    Package_ID INT PRIMARY KEY IDENTITY(1,1),
    Package_Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Duration_Days INT,
    Price DECIMAL(10,2) NOT NULL,
    Discount_Percentage DECIMAL(5,2) DEFAULT 0
);

--Creating Services Table
CREATE TABLE Services(
    Service_ID INT PRIMARY KEY IDENTITY(1,1),
    Service_Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10,2) NOT NULL,
    Service_CategoryID INT NOT NULL,
    Duration TIME NOT NULL
);

--Creating ServiceCategories Table
CREATE TABLE Service_Category(
    Category_ID INT PRIMARY KEY IDENTITY(1,1),
    Category_Name NVARCHAR(50) UNIQUE NOT NULL,
    Category_Description NVARCHAR(255)
);

--Creating Package_Services Table
CREATE TABLE Package_Services(
    Package_Service_ID INT PRIMARY KEY IDENTITY(1,1),
    Package_ID INT,
    ServiceID INT,
    QuantityIncluded INT DEFAULT 1,
    FOREIGN KEY (Package_ID) REFERENCES Packages(Package_ID),
    FOREIGN KEY (ServiceID) REFERENCES Services(Service_ID)
);

-- Creating Appointments Table
CREATE TABLE Appointments(
    Appointment_ID INT PRIMARY KEY IDENTITY(1,1),
    Pet_ID INT,
    Owner_ID INT,
    Staff_ID INT,
    Store_ID INT,
    Appointment_Date DATE NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    ServiceID INT,
    Package_Service_ID INT,
    Status NVARCHAR(50) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')) DEFAULT 'Scheduled',
    Notes NVARCHAR(255)
);

--Creating Medical Records Table
CREATE TABLE Medical_Records(
    Record_ID INT PRIMARY KEY IDENTITY(1,1),
    Pet_ID INT,
    Owner_ID INT,
    Staff_ID INT,
    Store_ID INT,
    Appointment_ID INT,
    Diagnosis NVARCHAR(255),
    Treatment NVARCHAR(255),
    Prescription NVARCHAR(255),
    Follow_Up_Date DATE,   
    Notes NVARCHAR(255)
);

--Creating Store Products Table
CREATE TABLE Products(
    Product_ID INT PRIMARY KEY IDENTITY(1,1),
    Product_Name NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL
);

--Creating Inventory Table
CREATE TABLE Inventory(
    Inventory_ID INT PRIMARY KEY IDENTITY(1,1),
    Store_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Reorder_Level INT NOT NULL,
    Supplier_ID INT NULL,
    Store_Price DECIMAL(10,2) NOT NULL,
    Last_Restock_Date DATE
);

--Creating Suppliers Table
CREATE TABLE Suppliers(
    Supplier_ID INT PRIMARY KEY IDENTITY(1,1),
    Supplier_Name NVARCHAR(100) NOT NULL,
    Contact_Name NVARCHAR(100),
    Contact_Email NVARCHAR(100) UNIQUE,
    Contact_Phone NVARCHAR(15),
    Address NVARCHAR(255)
);

-- Creating Payments Table
CREATE TABLE Payments(
    Payment_ID INT PRIMARY KEY IDENTITY(1,1),
    Owner_ID INT,
    Payment_Date DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Method NVARCHAR(50) CHECK (Payment_Method IN ('Credit Card', 'Debit Card', 'Cash', 'Mobile Payment', 'Insurance')),
    Payment_Status NVARCHAR(50) CHECK (Payment_Status IN ('Pending', 'Completed', 'Failed', 'Refunded')) DEFAULT 'Pending',
    Transaction_ID NVARCHAR(100) UNIQUE
);

--Creating Payment Details Table
CREATE TABLE Payment_Details(
    Payment_Detail_ID INT PRIMARY KEY IDENTITY(1,1),
    Payment_ID INT,
    Appointment_ID INT,
    Product_ID INT,
    Quantity INT DEFAULT 1,
    Total_Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Payment_ID) REFERENCES Payments(Payment_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointments(Appointment_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

--Creating Reviews Table
CREATE TABLE Reviews(
    Review_ID INT PRIMARY KEY IDENTITY(1,1),
    Owner_ID INT,
    Store_ID INT,
    Staff_ID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5) NOT NULL,
    Review_Text NVARCHAR(500),
    Review_Date DATE DEFAULT GETDATE()
);

--Creating Relationships
ALTER TABLE Pets
ADD FOREIGN KEY (Owner_ID) REFERENCES Pet_Owners(Owner_ID);

ALTER TABLE Staff
ADD FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID);

ALTER TABLE Pet_Conditions
ADD FOREIGN KEY (Pet_ID) REFERENCES Pets(Pet_ID);

ALTER TABLE Pet_Treatments
ADD FOREIGN KEY (Pet_ID) REFERENCES Pets(Pet_ID);

ALTER TABLE Staff_Availability
ADD FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID);

ALTER TABLE Services
ADD FOREIGN KEY (Service_CategoryID) REFERENCES Service_Category(Category_ID);

ALTER TABLE Appointments
ADD FOREIGN KEY (Pet_ID) REFERENCES Pets(Pet_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Pet_Owners(Owner_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (ServiceID) REFERENCES Services(Service_ID),
    FOREIGN KEY (Package_Service_ID) REFERENCES Package_Services(Package_Service_ID);

ALTER TABLE Medical_Records
ADD FOREIGN KEY (Pet_ID) REFERENCES Pets(Pet_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Pet_Owners(Owner_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointments(Appointment_ID);

ALTER TABLE Inventory
ADD FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(Supplier_ID);

ALTER TABLE Payments
ADD FOREIGN KEY (Owner_ID) REFERENCES Pet_Owners(Owner_ID);

ALTER TABLE Reviews
ADD FOREIGN KEY (Owner_ID) REFERENCES Pet_Owners(Owner_ID),
    FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID);

ALTER TABLE Payment_Details
ADD FOREIGN KEY (Payment_ID) REFERENCES Payments(Payment_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointments(Appointment_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID);

ALTER TABLE Package_Services
ADD FOREIGN KEY (Package_ID) REFERENCES Packages(Package_ID),
    FOREIGN KEY (ServiceID) REFERENCES Services(Service_ID);

ALTER TABLE Services
ADD FOREIGN KEY (Service_CategoryID) REFERENCES Service_Category(Category_ID);

ALTER TABLE Pet_Conditions
ADD FOREIGN KEY (Pet_ID) REFERENCES Pets(Pet_ID);

ALTER TABLE Pet_Treatments
ADD FOREIGN KEY (Pet_ID) REFERENCES Pets(Pet_ID);

ALTER TABLE Staff_Availability
ADD FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID);

EXEC sp_rename 'Stores.Store_Manager','Store_Manager_ID', 'COLUMN';

ALTER TABLE Stores
ALTER COLUMN Store_Manager_ID INT;

ALTER TABLE Stores
ADD FOREIGN KEY (Store_Manager_ID) REFERENCES Staff(Staff_ID);


-- Inserting Data Into Tables


-- Inserting Data into Stores Table
INSERT INTO Stores (Store_Name, Store_Address, Phone)
VALUES
('Pawfect Pet Care Abuja', '15 Jos Street Garki', '08012345678'),
('Pawfect Pet Care Lagos', '22 Allen Avenue Ikeja', '08087654321'),
('Pawfect Pet Care Port Harcourt', '5 Harbour Road', '08023456789'),
('Pawfect Pet Care Abuja-2', '30 Abidjan Street Wuse Zone 4', '08098765432'),
('Pawfect Pet Care Lagos-2', '10 Victoria Island', '08034567890');

-- Resetting Identity Seed for Stores Table as PK started at 2 for initial insert
DBCC CHECKIDENT ('Stores', NORESEED);
DBCC CHECKIDENT ('Stores', RESEED, 0);

INSERT INTO Stores (Store_Name, Store_Address, Phone) -- Will not insert Store_Manager_ID yet as Staff table is empty
VALUES
('Pawfect Care HQ','975 Central Business District Abuja','08011223344');

SELECT * FROM Stores;

--Inserting Data into Staff Table
INSERT INTO Staff (Store_ID, Staff_Name, Role, Specialty, Staff_Email, Staff_Phone, Hire_Date, Salary)
VALUES
('1', 'Dr. Efemena Omukudo', 'Manager', NULL, 'efemuko@gmail.com', '08012345678', '2020-01-15', 8000000.00),
('2', 'Dr. Emeka Wisdom', 'Manager', NULL, 'wizzy247@yahoo.com', '08087654321', '2020-03-22', 7500000.00),
('3', 'Dr. Amina Bello', 'Manager', NULL, 'aminab96@gmail.com', '08034662453', '2020-05-10', 7800000.00),
('4', 'Dr. Chinedu Okafor', 'Manager', NULL, 'chizzy4u@gmail.com', '08098765432', '2020-07-18', 6800000.00),
('5', 'Dr. Fatima Yusuf', 'Manager', NULL, 'yusufa55@yahoo.com', '08034567890', '2020-09-25', 7900000.00),
('6', 'Dr. Etim Udo', 'Manager', NULL, 'dodoetimi234@gmail.com', '08011223344', '2020-11-30', 7900000.00),
('1', 'Dr. Mark Malik', 'Veterinarian', 'Surgery', 'm.maliki@gmail.com', '08022334455', '2021-02-14', 5000000.00),
('2', 'Dr. Evans Kagho', 'Veterinarian', 'Surgery', 'ekaggy@yahoo.com', '08033445566', '2021-04-20', 5200000.00),
('3', 'Dr. Sarah Nwangwu', 'Veterinarian', 'Surgery', 'saranwan01@gmail.com', '08044556677', '2021-06-15', 5100000.00),
('4', 'Dr. John Okeke', 'Veterinarian', 'Surgery', 'jokeboy69@yahoo.com', '08055667788', '2021-08-10', 5300000.00),
('5', 'Dr. Aisha Abubakar', 'Veterinarian', 'Surgery', 'ayeeshabu09@gmail.com', '08066778899', '2021-10-05', 5400000.00),
('6', 'Dr. Peter Eze', 'Veterinarian', 'Surgery', 'zekepepe34@gmail.com', '08077889900', '2021-12-01', 5500000.00),
('1', 'Increase Oma', 'Vet Assistant', NULL, 'in4jesus@gmail.com', '08088990011', '2022-01-20', 2500000.00),
('2', 'Grace Ibe', 'Vet Assistant', NULL, 'gribe4lf@yahoo.com', '08099001122', '2022-03-18', 2100000.00),
('3', 'Linda Chukwu', 'Vet Assistant', NULL, 'linchuks22@gmail.com', '08010111223', '2022-05-15', 2200000.00),
('4', 'James Okoro', 'Vet Assistant', NULL, 'okjamie34@gmail.com', '08012131415', '2022-07-12', 2200000.00),
('5', 'Oghenerukevwe Odogbo', 'Vet Assistant', NULL, 'odogsru67@gmail.com', '08013141516', '2022-09-10', 2340000.00),
('6', 'Chinelo Nnaji', 'Vet Assistant', NULL, 'nnachilo62@yahoo.com', '08014151617', '2022-11-08', 2300000.00),
('1', 'Moses Akinyemi', 'Groomer', NULL, 'mokemi@yahoo.com', '08015161718', '2023-01-05', 1500000.00),
('2', 'Tina Williams', 'Groomer', NULL, 'tiwilly@hotmail.com', '08016171819', '2023-03-03', 1200000.00),
('3', 'Bola Johnson', 'Groomer', NULL, 'jobolaja@gmail.com', '08017181920', '2023-05-01', 1300000.00),
('4', 'Nana Abdulrashid', 'Groomer', NULL, 'rashinana@gmail.com', '08018192021', '2023-06-28', 1400000.00),
('5', 'Chika Chijioke', 'Groomer', NULL, 'okechi@gmail.com', '08019202122', '2023-08-25', 1350000.00),
('6', 'Sade Afolabi', 'Groomer', NULL, 'sadelabs99@gmail.com', '07033452544', '2023-08-15', 1330000.00),
('1', 'Emeka Okafor', 'Store Clerk', NULL, 'forameka34@gmail.com', '08020212223', '2023-01-10', 1000000.00),
('2', 'Chinwe Nwosu', 'Store Clerk', NULL, 'suswochi85@gmail.com', '08021222324', '2023-03-15', 1150000.00),
('3', 'Tunde Bakare', 'Store Clerk', NULL, 'bakagain.66@gmail.com', '08025432425', '2023-05-20', 1200000.00),
('4', 'Funke Obi', 'Store Clerk', NULL, 'funobi77@gmail.com', '08022432880', '2023-07-25', 1100000.00),
('5', 'Ahmed Musa', 'Store Clerk', NULL, 'ahmusa91@yahoo.com', '08023456789', '2023-09-30', 1250000.00),
('6', 'Richard Imade', 'Store Clerk', NULL, 'imari@hotmail.com', '08024567890', '2023-11-05', 1300000.00),
('2', 'Dr. Lucy Anozie', 'Veterinarian', 'Dermatology', 'luckyluce15@gmail.com', '08099887766', '2021-03-12', 5200000.00),
('3', 'Dr. Michael Eze', 'Veterinarian', 'Pathology', 'ezima49@gmail.com', '08088776655', '2021-05-18', 5100000.00),
('4', 'Dr. Rebecca Plagkat', 'Veterinarian', 'Wildlife', 'kattybeccy@outlook.com', '08077665544', '2021-07-22', 5300000.00),
('5', 'Dr. Orija Okonkwo', 'Veterinarian', 'Exotic Animals', 'jakonri00@gmail.com', '08066554433', '2021-09-30', 5400000.00),
('6', 'Dr. Linda Agbo', 'Veterinarian', 'Dentistry', 'linnyboo@outlook.com', '08055443322', '2021-11-25', 5500000.00),
('1', 'Blessing Okon', 'Vet Assistant', NULL, 'blessokon@gmail.com', '08030313233', '2023-02-10', 2400000.00),
('2', 'Samuel Ojo', 'Vet Assistant', NULL, 'sammyojo@yahoo.com', '08031323334', '2023-04-12', 2450000.00),
('3', 'Ngozi Uche', 'Groomer', NULL, 'ngozuche@gmail.com', '08032333435', '2023-06-15', 1450000.00),
('4', 'Ibrahim Sule', 'Store Clerk', NULL, 'ibsule@gmail.com', '08033343536', '2023-08-18', 1350000.00),
('5', 'Esther Akpan', 'Vet Assistant', NULL, 'estherakpan@gmail.com', '08034353637', '2023-10-20', 2500000.00),
('6', 'Chinedu Nwankwo', 'Groomer', NULL, 'chinedunwankwo@gmail.com', '08035363738', '2023-12-22', 1400000.00),
('1', 'Patience Eze', 'Store Clerk', NULL, 'patienceeze@gmail.com', '08036373839', '2024-01-05', 1200000.00),
('2', 'Victor Ade', 'Vet Assistant', NULL, 'victorade@gmail.com', '08037383940', '2024-02-10', 2550000.00),
('3', 'Rita Okeke', 'Groomer', NULL, 'ritaokeke@gmail.com', '08038394041', '2024-03-15', 1500000.00),
('4', 'Emmanuel Udo', 'Store Clerk', NULL, 'emmanueludo@gmail.com', '08039404142', '2024-04-20', 1400000.00),
('5', 'Helen Musa', 'Vet Assistant', NULL, 'helenmusa@gmail.com', '08040414243', '2024-05-25', 2600000.00),
('6', 'Oluwaseun Ajayi', 'Groomer', NULL, 'oluwaseunajayi@gmail.com', '08041424344', '2024-06-30', 1550000.00),
('1', 'Gloria Nwosu', 'Store Clerk', NULL, 'glorianwosu@gmail.com', '08042434445', '2024-07-05', 1250000.00),
('2', 'Kingsley Okoro', 'Vet Assistant', NULL, 'kingsleyokoro@gmail.com', '08043444546', '2024-08-10', 2650000.00),
('3', 'Maryam Bello', 'Groomer', NULL, 'maryambello@gmail.com', '08044454647', '2024-09-15', 1600000.00),
('4', 'Josephine Eze', 'Store Clerk', NULL, 'josephineeze@gmail.com', '08045464748', '2024-10-20', 1450000.00),
('5', 'Paul Okafor', 'Vet Assistant', NULL, 'paulokafor@gmail.com', '08046474849', '2024-11-25', 2700000.00),
('6', 'Adaobi Nnaji', 'Groomer', NULL, 'adaobinnaji@gmail.com', '08047484950', '2024-12-30', 1650000.00),
('1', 'Faith Garba', 'Store Clerk', NULL, 'gfaith@gmail.com', '08048495051', '2025-01-05', 1300000.00),
('2', 'Ifeanyi Obi', 'Vet Assistant', NULL, 'ifeanyiobi@gmail.com', '08049505152', '2025-02-10', 2750000.00);

SELECT * FROM Stores;
-- Insertting Store Manager IDs into Stores Table
UPDATE Stores
SET Store_Manager_ID = 1
WHERE Store_ID = 1;

UPDATE Stores
SET Store_Manager_ID = 2
WHERE Store_ID = 2;

UPDATE Stores
SET Store_Manager_ID = 3
WHERE Store_ID = 3;

UPDATE Stores
SET Store_Manager_ID = 4
WHERE Store_ID = 4;

UPDATE Stores
SET Store_Manager_ID = 5
WHERE Store_ID = 5;

UPDATE Stores
SET Store_Manager_ID = 6
WHERE Store_ID = 6;


SELECT * FROM Pet_Owners;
DBCC CHECKIDENT ('Staff', RESEED, 0);
-- Inserting Data into Owners Table
INSERT INTO Pet_Owners (Owner_Name, Email, Phone, Address)
VALUES
('Tunde Adeyemi', 'tunde.adeyemi@gmail.com', '08011113333', '101 Peter Odili Road, Port Harcourt'),
('Bisi Oladipo', 'bisi.oladipo@gmail.com', '08022224444', '202 Ring Road, Ikeja'),
('Musa Abdullahi', 'musa.abdullahi@gmail.com', '08033335555', '303 Ahmadu Bello Way, Abuja'),
('Efe Oghene', 'efe.oghene@gmail.com', '08044446666', '404 Awolowo Road, Ikoyi'),
('Chika Okeke', 'chika.okeke@gmail.com', '08055557777', '505 Rotimi Road, Port Harcourt'),
('Ayo Balogun', 'ayo.balogun@gmail.com', '08066668888', '123 New Central District, Abuja'),
('Funmi Adebayo', 'funmi.adebayo@gmail.com', '08077779999', '12 Bode George, Lagos'),
('Sani Bello', 'sani.bello@gmail.com', '08088880000', '8 Barnawa, Port Harcourt'),
('Kemi Ojo', 'kemi.ojo@gmail.com', '08099991111', '17 Peter Odili Road, Port Harcourt'),
('Gbenga Ogunleye', 'gbenga.ogunleye@gmail.com', '08101010222', '3 GRA, Port Harcourt'),
('Halima Yusuf', 'halima.yusuf@gmail.com', '08111111222', '6 Awolowo Road, Ikoyi'),
('Uche Nwosu', 'uche.nwosu@gmail.com', '08121212333', '14 Rayfield, Lekki'),
('Bola Ajayi', 'bola.ajayi@gmail.com', '08131313444', '21 Peter Odili Road, Port Harcourt'),
('Grace Eze', 'grace.eze@gmail.com', '08141414555', '9 Zik Avenue, Enugu'),
('Ifeanyi Okafor', 'ifeanyi.okafor@gmail.com', '08151515666', '25 Barnawa, Kaduna'),
('Aminu Lawal', 'aminu.lawal@gmail.com', '08161616777', '7 Ogunlana Drive, Surulere '),
('Ruth Akpan', 'ruth.akpan@gmail.com', '08171717888', '11 Peter Odili Road, Port Harcourt'),
('Chinedu Obi', 'chinedu.obi@gmail.com', '08181818999', '19 Ring Road, Ibadan'),
('Mariam Sulaiman', 'mariam.sulaiman@gmail.com', '08191919000', '2 Oyibo, Lekk'),
('Peter Okon', 'peter.okon@gmail.com', '08202020111', '13 Awolowo Road, Ikoyi'),
('Blessing Musa', 'blessing.musa@gmail.com', '08212121222', '27 Ozumba Mbadiwe Avenue, Victoria Island'),
('Emeka Udo', 'emeka.udo@gmail.com', '08222222333', '4 Bodija, Ibadan'),
('Fatima Bello', 'fatima.bello@gmail.com', '08232323444', '16 Peter Odili Road, Port Harcourt'),
('Samuel Nwankwo', 'samuel.nwankwo@gmail.com', '08242424555', '23 Ogunlana Drive, Surulere '),
('Helen Ade', 'helen.ade@gmail.com', '08252525666', '18 GRA, Benin'),
('Oluwaseun Ayinde', 'oluwaseun.ayinde@gmail.com', '08262626777', '20 Awolowo Road, Ikoyi'),
('Gloria Nwosu', 'gloria.nwosu@gmail.com', '08272727888', '28 Ada George Road, Port Harcourt'),
('Kingsley Okoro', 'kingsley.okoro@gmail.com', '08282828999', '15 Ogunlana Drive, Surulere '),
('Maryam Bello', 'maryam.bello@gmail.com', '08292929000', '29 Dar-Es-Salaam Street, Abuja'),
('Josephine Eze', 'josephineeze@gmail.com', '08303030111', '31 Ada George Road, Port Harcourt'),
('Paul Okafor', 'paul.okafor@gmail.com', '08313131222', '32 Peter Odili Road, Port Harcourt'),
('Adaobi Nnaji', 'adaobi.nnaji@gmail.com', '08323232333', '33 Adetokunbo Ademola Crescent, Abuja'),
('Faith Nnamdi', 'faith.nnamdi@gmail.com', '08333333444', '34 Dar-Es-Salaam Street, Abuja'),
('Ifeanyi Obi', 'ifeanyi.obi@gmail.com', '08343434555', '35 Adetokunbo Ademola Crescent, Abuja'),
('Adaora Nwankwo', 'adaora.nwankwo@gmail.com', '08353535666', '36 Ada George Road, Port Harcourt'),
('Ibrahim Suleiman', 'ibrahim.suleiman@gmail.com', '08363636777', '37 Adetokunbo Ademola Crescent, Abuja'),
('Gloria Nedum', 'gloria.nedum@gmail.com', '08444444555', '45 Adetokunbo Ademola Crescent, Abuja'),
('Faith Chukwu', 'faith.chukwu@gmail.com', '08505050111', '51 Broad Street, Lagos Island');

-- Populating Pets Table
INSERT INTO Pets (Owner_ID, Pet_Name, Species, Breed, Gender, Age, Weight)
VALUES
(101, 'Max', 'Dog', 'Local', 'Male', 3, 18.5),
(101, 'Bella', 'Dog', 'Alsatian', 'Female', 2, 22.0),
(109, 'Tiger', 'Cat', 'Local', 'Male', 4, 5.2),
(132, 'Lucky', 'Dog', 'Rottweiler', 'Male', 5, 30.0),
(104, 'Chichi', 'Cat', 'Local', 'Female', 1, 3.8),
(138, 'Rocky', 'Dog', 'Boerboel', 'Male', 2, 25.5),
(133, 'Simba', 'Cat', 'Local', 'Male', 3, 4.1),
(122, 'Milo', 'Dog', 'Lhasa Apso', 'Male', 1, 7.0),
(111, 'Princess', 'Dog', 'Local', 'Female', 4, 16.0),
(112, 'Shadow', 'Cat', 'Local', 'Male', 2, 4.5),
(118, 'Bingo', 'Dog', 'Local', 'Male', 6, 20.0),
(120, 'Snowy', 'Cat', 'Local', 'Female', 2, 3.9),
(121, 'Rex', 'Dog', 'Alsatian', 'Male', 3, 24.0),
(122, 'Lulu', 'Cat', 'Local', 'Female', 5, 4.0),
(123, 'Daisy', 'Dog', 'Boerboel', 'Female', 2, 23.5),
(124, 'Coco', 'Cat', 'Local', 'Female', 1, 3.5),
(125, 'Jack', 'Dog', 'Local', 'Male', 4, 19.0),
(126, 'Toby', 'Dog', 'Lhasa Apso', 'Male', 2, 8.0),
(127, 'Mimi', 'Cat', 'Local', 'Female', 3, 4.2),
(128, 'Oscar', 'Dog', 'Rottweiler', 'Male', 5, 32.0),
(129, 'Pepper', 'Cat', 'Local', 'Male', 2, 4.3),
(130, 'Benji', 'Dog', 'Local', 'Male', 1, 15.0),
(131, 'Nala', 'Cat', 'Local', 'Female', 4, 4.7),
(132, 'Sam', 'Dog', 'Boerboel', 'Male', 3, 26.0),
(133, 'Angel', 'Cat', 'Local', 'Female', 2, 3.6),
(134, 'Bruno', 'Dog', 'Alsatian', 'Male', 4, 21.0),
(135, 'Sandy', 'Cat', 'Local', 'Female', 1, 3.2),
(136, 'Charlie', 'Dog', 'Local', 'Male', 5, 17.5),
(137, 'Paws', 'Cat', 'Local', 'Male', 3, 4.0),
(138, 'Rover', 'Dog', 'Boerboel', 'Male', 2, 24.0),
(121, 'Whiskers', 'Cat', 'Local', 'Female', 4, 4.4),
(132, 'Bolt', 'Dog', 'Lhasa Apso', 'Male', 1, 7.5),
(123, 'Fluffy', 'Cat', 'Local', 'Female', 2, 3.7),
(123, 'Spot', 'Dog', 'Local', 'Male', 3, 16.0),
(115, 'Ginger', 'Cat', 'Local', 'Female', 5, 4.1),
(106, 'Leo', 'Dog', 'Rottweiler', 'Male', 4, 29.0),
(111, 'Titi', 'Cat', 'Local', 'Female', 2, 3.8),
(119, 'Scooby', 'Dog', 'Boerboel', 'Male', 1, 22.0),
(103, 'Oreo', 'Cat', 'Local', 'Male', 3, 4.5),
(104, 'Fido', 'Dog', 'Alsatian', 'Male', 2, 20.0),
(114, 'Sisi', 'Cat', 'Local', 'Female', 4, 4.2),
(117, 'Maggie', 'Dog', 'Local', 'Female', 5, 18.0),
(119, 'Tom', 'Cat', 'Local', 'Male', 1, 3.9),
(124, 'Rufus', 'Dog', 'Boerboel', 'Male', 3, 25.0),
(134, 'Nina', 'Cat', 'Local', 'Female', 2, 3.6),
(126, 'Jerry', 'Dog', 'Lhasa Apso', 'Male', 4, 8.5),
(110, 'Bisi', 'Cat', 'Local', 'Female', 1, 3.3),
(118, 'Duke', 'Dog', 'Local', 'Male', 2, 17.0),
(125, 'Mocha', 'Cat', 'Local', 'Female', 3, 4.0),
(120, 'Randy', 'Dog', 'Boerboel', 'Male', 5, 27.0),
(113, 'Tunde', 'Cat', 'Local', 'Male', 2, 4.1),
(117, 'Lola', 'Dog', 'Alsatian', 'Female', 3, 21.5),
(115, 'Kiki', 'Cat', 'Local', 'Female', 4, 4.3);


-- Inserting Data into the Products Table
DBCC CHECKIDENT ('Products', RESEED, 0);
INSERT INTO Products (Product_Name, Category)
VALUES
('Royal Canin Adult Dog Food', 'Pet Food'),
('Hills Science Diet Cat Food', 'Pet Food'),
('Blue Buffalo Puppy Food', 'Pet Food'),
('Purina Pro Plan Senior Dog Food', 'Pet Food'),
('Whiskas Adult Cat Food', 'Pet Food'),
('Orijen Six Fish Dog Food', 'Pet Food'),
('Wellness CORE Grain-Free Cat Food', 'Pet Food'),
('Nutro Natural Choice Dog Food', 'Pet Food'),
('IAMS Healthy Naturals Cat Food', 'Pet Food'),
('Taste of the Wild Dog Food', 'Pet Food'),
('Heartgard Plus Heartworm Prevention', 'Medication'),
('Frontline Plus Flea & Tick Treatment', 'Medication'),
('Metacam Pain Relief', 'Medication'),
('Adequan Canine Joint Injection', 'Medication'),
('Baytril Antibiotic Tablets', 'Medication'),
('Prednisone Anti-inflammatory', 'Medication'),
('Tramadol Pain Medication', 'Medication'),
('Cerenia Anti-nausea Medication', 'Medication'),
('Insulin for Diabetic Pets', 'Medication'),
('Thyroid Medication', 'Medication'),
('Leather Dog Collar', 'Pet Accessories'),
('Retractable Dog Leash', 'Pet Accessories'),
('Stainless Steel Food Bowl', 'Pet Accessories'),
('Automatic Water Dispenser', 'Pet Accessories'),
('Pet Carrier Bag', 'Pet Accessories'),
('Memory Foam Pet Bed', 'Pet Accessories'),
('Interactive Puzzle Toy', 'Pet Accessories'),
('Scratching Post for Cats', 'Pet Accessories'),
('Pet ID Tag', 'Pet Accessories'),
('Dog Harness', 'Pet Accessories'),
('Pet Nail Clippers', 'Grooming'),
('Dog Shampoo & Conditioner', 'Grooming'),
('Cat Grooming Brush', 'Grooming'),
('Pet Toothbrush Set', 'Grooming'),
('Ear Cleaning Solution', 'Grooming'),
('Pet Wipes', 'Grooming'),
('De-shedding Tool', 'Grooming'),
('Pet Hair Dryer', 'Grooming'),
('Flea Shampoo', 'Grooming'),
('Waterless Pet Shampoo', 'Grooming'),
('Digital Pet Thermometer', 'Medical Supplies'),
('Surgical Gloves (Box)', 'Medical Supplies'),
('Pet Bandages', 'Medical Supplies'),
('Antiseptic Solution', 'Medical Supplies'),
('Disposable Syringes', 'Medical Supplies'),
('Pet Cone/E-Collar', 'Medical Supplies'),
('Medical Tape', 'Medical Supplies'),
('Gauze Pads', 'Medical Supplies'),
('Pet First Aid Kit', 'Medical Supplies'),
('IV Fluids', 'Medical Supplies'),
('Omega-3 Fish Oil Capsules', 'Supplements'),
('Glucosamine Joint Support', 'Supplements'),
('Probiotics for Digestive Health', 'Supplements'),
('Multivitamin for Dogs', 'Supplements'),
('Calcium Supplements', 'Supplements');
SELECT * FROM Products

-- Populating Product Supplier Table
DBCC CHECKIDENT ('Product', RESEED, 0);
SELECT * FROM Suppliers
INSERT INTO Suppliers (Supplier_Name, Contact_Name, Contact_Email, Contact_Phone, Address)
VALUES
('Vet Care Nigeria Ltd', 'Dr. Adebayo Ogundimu', 'adebayo@vetcareng.com', '08034567890', '15 Broad Street, Lagos Island, Lagos State'),
('Pet World Supplies', 'Mrs. Folake Adeniyi', 'folake@petworldng.com', '08052345678', '42 Allen Avenue, Ikeja, Lagos State'),
('Royal Canines Nigeria', 'Mr. Chukwuma Okafor', 'chukwuma@royalcanin.ng', '08078901234', '23 Victoria Island Way, Victoria Island, Lagos State'),
('MedVet Pharmaceuticals', 'Dr. Kemi Olabode', 'kemi@medvetpharma.ng', '08095678901', '78 Apapa Road, Apapa, Lagos State'),
('Purina Pet Foods Nigeria', 'Mr. Emeka Nwosu', 'emeka@purina.ng', '08063456789', '101 Lekki Phase 1, Lekki, Lagos State'),
('Peppa Pet Store', 'Mrs. Grace Okoro', 'grace@abujapetstore.ng', '0-9082345678', '23 Wuse 2 Shopping Complex, Wuse, Abuja FCT'),
('Fromo Veterinary Supplies', 'Dr. Musa Abdullahi', 'musa@fedvet.ng', '09073456789', '67 Central Business District, Central Area, Abuja FCT'),
('Nexus Animal Care', 'Mr. Daniel Ogbonna', 'daniel@nexusanimal.ng', '09054567890', '12 Gwarinpa Estate, Gwarinpa, Abuja FCT'),
('ProVet Medical Supplies', 'Dr. Hauwa Sani', 'hauwa@provet.ng', '0-9035678901', '78 Kubwa Main Market, Kubwa, Abuja FCT'),
('Trinity Pet Products', 'Mrs. Ngozi Eze', 'ngozi@trinitypet.ng', '0-904-6789012', '34 Maitama District, Maitama, Abuja FCT'),
('Virbac Nigeria', 'Dr. Segun Adeyemi', 'segun@virbac.ng', '09027890123', '56 Jabi Lake Mall, Jabi, Abuja FCT'),
('Blue Buffalo Nigeria', 'Mr. Kabiru Hassan', 'kabiru@bluebuffalo.ng', '09018901234', '89 Lugbe Shopping Plaza, Lugbe, Abuja FCT'),
('Blessings & Co. Vet Supplies', 'Dr. Blessing Amadi', 'blessing@riversvet.ng', '08032345678', '15 Trans-Amadi Industrial Layout, Port Harcourt, Rivers State'),
('Garden City Pet Care', 'Mr. Kingsley Wokoma', 'kingsley@gardencitypet.ng', '08053456789', '67 GRA Phase 2, Port Harcourt, Rivers State'),
('Niger Delta Animal Health', 'Dr. Joy Okwu', 'joy@ndanimalhealth.ng', '08074567890', '23 Rumuola Road, Port Harcourt, Rivers State'),
('Port Harcourt Pet Mart', 'Mrs. Comfort Briggs', 'comfort@phpetmart.ng', '08095678901', '45 Mile 3 Diobu, Port Harcourt, Rivers State'),
('South-South Vet Distributors', 'Mr. Victor Nkem', 'victor@southvet.ng', '0806-6789012', '78 Old Aba Road, Port Harcourt, Rivers State'),
('Coastal Animal Supplies', 'Dr. Precious Onyema', 'precious@coastalanimal.ng', '08047890123', '12 Creek Road, Port Harcourt, Rivers State'),
('Eleme Pet Products', 'Mr. Godwin Elechi', 'godwin@elemepet.ng', '08088901234', '34 Eleme Junction, Eleme, Rivers State'),
('Oily F Supplies', 'Dr. Chinelo Okorie', 'chinelo@oilcityvet.ng', '08029012345', '56 Stadium Road, Port Harcourt, Rivers State');

-- Populating Service Category Table
DBCC CHECKIDENT ('Service_Category', RESEED, 0);
SELECT * FROM Service_Category
INSERT INTO Service_Category (Category_Name, Category_Description)
VALUES
('Medical Consultation', 'General health examinations, diagnosis, and medical consultations for pets including routine check-ups and sick visits'),
('Surgical Services', 'Surgical procedures including spaying, neutering, tumor removal, orthopedic surgeries, and emergency surgical interventions'),
('Grooming & Hygiene', 'Professional pet grooming services including bathing, nail trimming, hair cutting, ear cleaning, and dental hygiene care'),
('Preventive Care', 'Vaccination programs, parasite prevention, health screenings, and wellness packages to maintain optimal pet health'),
('Emergency Care', 'Urgent and critical care services for injured or severely ill pets including after-hours emergency treatments'),
('Diagnostic Services', 'Laboratory tests, imaging services, blood work, X-rays, ultrasounds, and other diagnostic procedures for accurate health assessment');

--Populating Services Table
DBCC CHECKIDENT ('Services', RESEED, 0);
INSERT INTO Services (Service_Name, [Description],Price, Service_CategoryID,Duration)
VALUES
('General Health Check-up', 'Complete physical exam and health assessment', 15000.00, 1, '00:30:00'),
('Vaccination Package', 'Core vaccines including rabies and distemper', 25000.00, 4, '00:20:00'),
('Spay/Neuter Surgery', 'Surgical sterilization with pre and post-op care', 45000.00, 2, '02:00:00'),
('Full Grooming Service', 'Bath, nail trim, ear cleaning, and hair cut', 12000.00, 3, '01:30:00'),
('Blood Work Analysis', 'Complete blood count and chemistry panel', 18000.00, 5, '00:15:00'),
('Dental Cleaning', 'Professional dental scaling under anesthesia', 35000.00, 3, '01:45:00'),
('Emergency Consultation', 'Urgent assessment and initial treatment', 30000.00, 5, '00:45:00'),
('X-Ray Imaging', 'Radiographic exam for fractures and injuries', 22000.00, 5, '00:25:00'),
('Flea and Tick Treatment', 'Parasite treatment and prevention', 8000.00, 4, '00:20:00'),
('Wound Treatment', 'Cleaning and dressing of wounds', 10000.00, 3, '00:40:00');

--Populating Packages Table
DBCC CHECKIDENT ('Packages', RESEED, 0);
INSERT INTO Packages (Package_Name,[Description],Duration_Days,Price,Discount_Percentage)
VALUES
('Puppy Wellness Package', 'Complete puppy care including vaccinations, health check, and deworming', 90, 45000.00, 15.00),
('Senior Pet Care Package', 'Comprehensive health monitoring for senior pets with regular check-ups', 180, 65000.00, 20.00),
('Premium Grooming Package', 'Full grooming service with nail trim, dental cleaning, and flea treatment', 30, 38000.00, 12.00),
('Emergency Care Package', 'Priority emergency services with 24/7 availability and follow-up care', 365, 85000.00, 10.00),
('Basic Health Package', 'Essential health services including vaccination and routine examination', 120, 32000.00, 18.00),
('Dental Care Package', 'Complete dental health program with cleaning and oral examination', 60, 42000.00, 15.00),
('Surgical Care Package', 'Comprehensive surgical package with pre-op, surgery, and post-op care', 45, 78000.00, 8.00),
('Annual Wellness Package', 'Year-round health maintenance with quarterly check-ups and vaccinations', 365, 95000.00, 25.00);

--Populating Package Services Table
SELECT * FROM Package_Services
INSERT INTO Package_Services (Package_ID,ServiceID,QuantityIncluded)
VALUES 
(1, 23, 2),  -- General Health Check-up (2 visits)
(1, 24, 1),  -- Vaccination Package
(1, 31, 1),  -- Flea and Tick Treatment
(2, 23, 4),  -- General Health Check-up (quarterly)
(2, 27, 2),  -- Blood Work Analysis (twice)
(2, 30, 1),  -- X-Ray Imaging
(3, 26, 2),  -- Full Grooming Service (2 sessions)
(3, 28, 1),  -- Dental Cleaning
(3, 31, 1),  -- Flea and Tick Treatment
(4, 29, 3),  -- Emergency Consultation (3 incidents)
(4, 30, 2),  -- X-Ray Imaging (2 times)
(4, 32, 2),  -- Wound Treatment (2 incidents)
(5, 23, 2),  -- General Health Check-up (2 visits)
(5, 24, 1),  -- Vaccination Package
(5, 27, 1),  -- Blood Work Analysis
(6, 23, 1),  -- General Health Check-up
(6, 28, 1),  -- Dental Cleaning
(6, 27, 1),  -- Blood Work Analysis (pre-anesthesia)
(7, 25, 1),  -- Spay/Neuter Surgery
(7, 27, 2),  -- Blood Work Analysis (pre & post-op)
(7, 23, 2);  -- General Health Check-up (follow-ups)

--Populating Appointments Table
SELECT * FROM Package_Services
DBCC CHECKIDENT ('Appointments', RESEED, 0);
INSERT INTO Appointments (Pet_ID,Owner_ID,Staff_ID, Store_ID,Appointment_Date,Start_Time,End_Time,ServiceID,Package_Service_ID,[Status], Notes)
VALUES
(15, 105, 12, 1, '2024-09-15', '09:00:00', '09:30:00', NULL, 45, 'Completed', 'Annual check-up completed successfully'),
(23, 112, 8, 2, '2024-09-16', '10:30:00', '10:50:00', NULL, 47, 'Completed', 'Wellness package administered'),
(7, 103, 25, 3, '2024-09-17', '14:00:00', '16:00:00', 25, NULL, 'Scheduled', 'Pre-surgical fasting instructions given'),
(31, 118, 33, 4, '2024-09-18', '11:00:00', '12:30:00', 26, NULL, 'Scheduled', 'First grooming appointment'),
(42, 127, 19, 5, '2024-09-19', '08:30:00', '08:45:00', 27, NULL, 'Completed', 'Blood work shows normal values'),
(9, 104, 41, 6, '2024-09-20', '15:30:00', '17:15:00', 28, NULL, 'Scheduled', 'Heavy tartar buildup noted'),
(18, 108, 14, 1, '2024-09-21', '16:00:00', '16:45:00', 29, NULL, 'Completed', 'Emergency treated - laceration on paw'),
(36, 122, 28, 2, '2024-09-22', '13:20:00', '13:45:00', 30, NULL, 'Scheduled', 'Suspected foreign object ingestion'),
(5, 102, 37, 3, '2024-09-23', '09:15:00', '09:35:00', 31, NULL, 'Completed', 'Flea infestation treated successfully'),
(27, 115, 46, 4, '2024-09-24', '10:45:00', '11:25:00', 32, NULL, 'Scheduled', 'Minor bite wound from dog fight'),
(13, 106, 22, 5, '2024-09-25', '14:30:00', '15:00:00', 23, NULL, 'Cancelled', 'Owner rescheduled due to travel'),
(29, 117, 11, 6, '2024-09-26', '08:00:00', '08:20:00', NULL, 53, 'Scheduled', 'Puppy vaccination package - 2nd visit'),
(44, 129, 35, 1, '2024-09-27', '11:30:00', '13:30:00', 25, NULL, 'Scheduled', 'Spay surgery for 8-month-old cat'),
(21, 110, 17, 2, '2024-09-28', '16:30:00', '18:00:00', 26, NULL, 'Completed', 'Senior dog grooming - arthritis noted'),
(38, 124, 43, 3, '2024-09-29', '09:30:00', '09:45:00', 27, NULL, 'No-Show', 'Owner did not attend appointment'),
(12, 105, 26, 4, '2024-09-30', '12:00:00', '13:45:00', 28, NULL, 'Scheduled', 'Routine dental cleaning'),
(33, 119, 20, 5, '2024-10-01', '15:00:00', '15:45:00', 29, NULL, 'Completed', 'Allergic reaction - stabilized'),
(6, 103, 49, 6, '2024-10-02', '10:00:00', '10:25:00', 30, NULL, 'Scheduled', 'Limping - X-ray to check for fracture'),
(25, 114, 31, 1, '2024-10-03', '13:45:00', '14:05:00', 31, NULL, 'Completed', 'Tick prevention applied'),
(47, 132, 15, 2, '2024-10-04', '11:15:00', '11:55:00', 32, NULL, 'Scheduled', 'Cleaning infected scratch'),
(8, 104, 39, 3, '2024-10-05', '08:45:00', '09:15:00', 23, NULL, 'Scheduled', 'Follow-up examination after surgery'),
(35, 121, 24, 4, '2024-10-06', '14:15:00', '14:35:00', NULL, 55, 'Cancelled', 'Pet illness - owner requested postponement'),
(19, 109, 52, 5, '2024-10-07', '16:45:00', '17:30:00', 26, NULL, 'Scheduled', 'Full service grooming for show preparation'),
(41, 126, 18, 6, '2024-10-08', '09:00:00', '09:15:00', 27, NULL, 'Completed', 'Pre-anesthetic blood work cleared'),
(14, 107, 45, 1, '2024-10-09', '12:30:00', '14:15:00', 28, NULL, 'Scheduled', 'Dental surgery - multiple extractions needed'),
(30, 118, 29, 2, '2024-10-10', '10:20:00', '11:05:00', 29, NULL, 'Completed', 'Hit by car - treated for shock'),
(50, 135, 36, 3, '2024-10-11', '15:15:00', '15:40:00', 30, NULL, 'No-Show', 'Unable to contact owner'),
(4, 102, 13, 4, '2024-10-12', '11:45:00', '12:05:00', 31, NULL, 'Scheduled', 'Monthly flea and tick prevention'),
(22, 111, 48, 5, '2024-10-13', '13:00:00', '14:30:00', NULL, 64, 'Completed', 'Premium grooming package completed'),
(37, 123, 40, 6, '2024-10-14', '16:15:00', '16:55:00', 32, NULL, 'Scheduled', 'Post-operative wound check');

