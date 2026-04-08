-- edU Save Database
DROP DATABASE IF EXISTS edusave;
CREATE DATABASE edusave;
USE edusave;


-- University table
DROP TABLE IF EXISTS University;
CREATE TABLE University (
  Uni_Id      INT             NOT NULL AUTO_INCREMENT,
  Uni_Name    VARCHAR(100)    NOT NULL,
  State       VARCHAR(100)    NOT NULL,
  City        VARCHAR(100)    NOT NULL,
  Uni_Lat     FLOAT           NULL,
  Uni_Lng     FLOAT           NULL,
  PRIMARY KEY (Uni_Id)
);


-- Category table
DROP TABLE IF EXISTS Category;
CREATE TABLE Category (
  Category_Id     INT             NOT NULL AUTO_INCREMENT,
  Category_Name   VARCHAR(100)    NOT NULL,
  PRIMARY KEY (Category_Id)
);


-- Student table
DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
  Student_Id      INT             NOT NULL AUTO_INCREMENT,
  Uni_Id          INT             NOT NULL,
  First_Name      VARCHAR(100)    NOT NULL,
  Last_Name       VARCHAR(100)    NOT NULL,
  Username        VARCHAR(100)    NOT NULL,
  Student_Email   VARCHAR(100)    NOT NULL,
  Student_Type    VARCHAR(100)    NULL,
  Grad_Year       YEAR            NOT NULL,
  Verified_Status TINYINT         NOT NULL DEFAULT 0,
  PRIMARY KEY (Student_Id),
  CONSTRAINT fk_student_uni
      FOREIGN KEY (Uni_Id) REFERENCES University (Uni_Id)
);


-- Admin table
DROP TABLE IF EXISTS Admin;
CREATE TABLE Admin (
  Admin_Id    INT             NOT NULL AUTO_INCREMENT,
  Admin_Name  VARCHAR(100)    NOT NULL,
  Admin_Role  VARCHAR(100)    NOT NULL,
  PRIMARY KEY (Admin_Id)
);


-- Business table
DROP TABLE IF EXISTS Business;
CREATE TABLE Business (
  Biz_Id          INT             NOT NULL AUTO_INCREMENT,
  Biz_Name        VARCHAR(100)    NOT NULL,
  Website         VARCHAR(100)    NULL,
  Address         VARCHAR(100)    NULL,
  Account_Status  TINYINT         NOT NULL DEFAULT 1,
  Joined_Date     DATETIME        NOT NULL,
  Verified_Status TINYINT         NOT NULL DEFAULT 0,
  Biz_Lat         FLOAT           NULL,
  Biz_Lng         FLOAT           NULL,
  PRIMARY KEY (Biz_Id)
);


-- Business_Owner table
DROP TABLE IF EXISTS Business_Owner;
CREATE TABLE Business_Owner (
  Owner_Id    INT             NOT NULL AUTO_INCREMENT,
  Biz_Id      INT             NOT NULL,
  Uni_Id      INT             NOT NULL,
  Owner_Name  VARCHAR(100)    NOT NULL,
  Owner_Email VARCHAR(100)    NOT NULL,
  Owner_Phone VARCHAR(20)     NOT NULL,
  PRIMARY KEY (Owner_Id),
  CONSTRAINT fk_owner_biz
      FOREIGN KEY (Biz_Id) REFERENCES Business (Biz_Id),
  CONSTRAINT fk_owner_uni
      FOREIGN KEY (Uni_Id) REFERENCES University (Uni_Id)
);


-- Discount table
DROP TABLE IF EXISTS Discount;
CREATE TABLE Discount (
  Discount_Id     INT             NOT NULL AUTO_INCREMENT,
  Biz_Id          INT             NOT NULL,
  Category_Id     INT             NOT NULL,
  Disc_Title      VARCHAR(100)    NOT NULL,
  Disc_Amount     INT             NOT NULL,
  Disc_Status     TINYINT         NOT NULL DEFAULT 1,
  Created_At      DATETIME        NOT NULL,
  Promo_Code      VARCHAR(50)     NULL,
  PRIMARY KEY (Discount_Id),
  CONSTRAINT fk_discount_biz
      FOREIGN KEY (Biz_Id) REFERENCES Business (Biz_Id),
  CONSTRAINT fk_discount_category
      FOREIGN KEY (Category_Id) REFERENCES Category (Category_Id)
);


-- Saved_Discount table
DROP TABLE IF EXISTS Saved_Discount;
CREATE TABLE Saved_Discount (
  Saved_Id    INT         NOT NULL AUTO_INCREMENT,
  Student_Id  INT         NOT NULL,
  Discount_Id INT         NOT NULL,
  Saved_At    DATETIME    NOT NULL,
  PRIMARY KEY (Saved_Id),
  CONSTRAINT fk_saved_student
      FOREIGN KEY (Student_Id) REFERENCES Student (Student_Id),
  CONSTRAINT fk_saved_discount
      FOREIGN KEY (Discount_Id) REFERENCES Discount (Discount_Id)
);


-- Shared_Discount table
DROP TABLE IF EXISTS Shared_Discount;
CREATE TABLE Shared_Discount (
  Share_Id    INT         NOT NULL AUTO_INCREMENT,
  Sender_Id   INT         NOT NULL,
  Reciever_Id INT         NOT NULL,
  Discount_Id INT         NOT NULL,
  Saved_At    DATETIME    NOT NULL,
  PRIMARY KEY (Share_Id),
  CONSTRAINT fk_shared_sender
      FOREIGN KEY (Sender_Id) REFERENCES Student (Student_Id),
  CONSTRAINT fk_shared_reciever
      FOREIGN KEY (Reciever_Id) REFERENCES Student (Student_Id),
  CONSTRAINT fk_shared_discount
      FOREIGN KEY (Discount_Id) REFERENCES Discount (Discount_Id)
);


-- Report table
DROP TABLE IF EXISTS Report;
CREATE TABLE Report (
  Report_Id    INT            NOT NULL AUTO_INCREMENT,
  Student_Id   INT            NOT NULL,
  Discount_Id  INT            NOT NULL,
  Admin_Id     INT            NOT NULL,
  Report_Msg   TEXT           NOT NULL,
  Submitted_At DATETIME       NOT NULL,
  Priority     TINYINT        NOT NULL DEFAULT 1,
  Resolution   TEXT           NULL,
  PRIMARY KEY (Report_Id),
  CONSTRAINT fk_report_student
      FOREIGN KEY (Student_Id) REFERENCES Student (Student_Id),
  CONSTRAINT fk_report_discount
      FOREIGN KEY (Discount_Id) REFERENCES Discount (Discount_Id),
  CONSTRAINT fk_report_admin
      FOREIGN KEY (Admin_Id) REFERENCES Admin (Admin_Id)
);


-- Notification table
DROP TABLE IF EXISTS Notification;
CREATE TABLE Notification (
  Notif_Id    INT             NOT NULL AUTO_INCREMENT,
  Student_Id  INT             NOT NULL,
  Notif_Type  VARCHAR(100)    NULL,
  Notif_Msg   TEXT            NOT NULL,
  Sent_Date   DATETIME        NOT NULL,
  PRIMARY KEY (Notif_Id),
  CONSTRAINT fk_notif_student
      FOREIGN KEY (Student_Id) REFERENCES Student (Student_Id)
);


-- Listing_Analytics table
DROP TABLE IF EXISTS Listing_Analytics;
CREATE TABLE Listing_Analytics (
  Analytics_Id        INT     NOT NULL AUTO_INCREMENT,
  Disc_Id             INT     NOT NULL,
  View_Count          INT     NOT NULL DEFAULT 0,
  Save_Count          INT     NOT NULL DEFAULT 0,
  Redemption_Count    INT     NOT NULL DEFAULT 0,
  PRIMARY KEY (Analytics_Id),
  CONSTRAINT fk_analytics_disc
      FOREIGN KEY (Disc_Id) REFERENCES Discount (Discount_Id)
);


-- Traffic_Snapshot table
DROP TABLE IF EXISTS Traffic_Snapshot;
CREATE TABLE Traffic_Snapshot (
  Snapshot_Id     INT             NOT NULL AUTO_INCREMENT,
  Biz_Id          INT             NOT NULL,
  Period_Start    DATETIME        NOT NULL,
  Period_End      DATETIME        NOT NULL,
  Period_Label    VARCHAR(100)    NOT NULL,
  Traffic_Count   INT             NOT NULL DEFAULT 0,
  PRIMARY KEY (Snapshot_Id),
  CONSTRAINT fk_traffic_biz
      FOREIGN KEY (Biz_Id) REFERENCES Business (Biz_Id)
);


-- Competitor_Listing table
DROP TABLE IF EXISTS Competitor_Listing;
CREATE TABLE Competitor_Listing (
  Competitor_Id    INT             NOT NULL AUTO_INCREMENT,
  Biz_Id           INT             NOT NULL,
  Biz_Name         VARCHAR(100)    NOT NULL,
  Disc_Amount      INT             NOT NULL,
  Redemption_Count INT             NOT NULL DEFAULT 0,
  View_Count       INT             NOT NULL DEFAULT 0,
  PRIMARY KEY (Competitor_Id),
  CONSTRAINT fk_competitor_biz
      FOREIGN KEY (Biz_Id) REFERENCES Business (Biz_Id)
);


-- Platform_Metrics table
DROP TABLE IF EXISTS Platform_Metrics;
CREATE TABLE Platform_Metrics (
  Metrics_Id      INT         NOT NULL AUTO_INCREMENT,
  Biz_Id          INT         NOT NULL,
  Total_Users     INT         NOT NULL DEFAULT 0,
  Active_Discs    INT         NOT NULL DEFAULT 0,
  Pending_Rpts    INT         NOT NULL DEFAULT 0,
  Snapshot_Date   DATETIME    NOT NULL,
  PRIMARY KEY (Metrics_Id),
  CONSTRAINT fk_metrics_biz
      FOREIGN KEY (Biz_Id) REFERENCES Business (Biz_Id)
);


-- ============================================================
-- Sample Data
-- ============================================================


-- Universities
INSERT INTO University (Uni_Name, State, City, Uni_Lat, Uni_Lng) VALUES
  ('Northeastern University', 'Massachusetts', 'Boston', 42.3398, -71.0892),
  ('Boston University', 'Massachusetts', 'Boston', 42.3505, -71.1054),
  ('MIT', 'Massachusetts', 'Cambridge', 42.3601, -71.0942);


-- Categories
INSERT INTO Category (Category_Name) VALUES
  ('Food'),
  ('Clothing'),
  ('Electronics');


-- Students
INSERT INTO Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) VALUES
  (1, 'Arjun', 'Patel', 'arjun_p', 'patel.arj@northeastern.edu', 'International', 2027, 1),
  (2, 'Mark', 'Smith', 'marksmith', 'smith.mark@bu.edu', 'Domestic', 2026, 1),
  (1, 'Emily', 'Chen', 'echen', 'chen.em@northeastern.edu', 'Domestic', 2028, 0);


-- Admins
INSERT INTO Admin (Admin_Name, Admin_Role) VALUES
  ('Jake Mallory', 'System Admin'),
  ('Sarah Thompson', 'Content Moderator');


-- Businesses
INSERT INTO Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) VALUES
  ('Campus Pizza', 'www.campuspizza.com', '123 Huntington Ave', 1, '2025-09-15 10:00:00', 1, 42.3396, -71.0891),
  ('BookNook', 'www.booknook.com', '45 Newbury St', 1, '2025-10-01 14:30:00', 1, 42.3510, -71.0810),
  ('TechDeals', 'www.techdeals.com', NULL, 0, '2026-01-20 09:00:00', 0, NULL, NULL);


-- Business Owners
INSERT INTO Business_Owner (Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) VALUES
  (1, 1, 'Sofia Reyes', 'sofia@campuspizza.com', '5551234567'),
  (2, 2, 'James Lee', 'james@booknook.com', '5555678901');


-- Discounts
INSERT INTO Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) VALUES
  (1, 1, '20% Off Large Pizzas', 20, 1, '2026-01-10 12:00:00', 'PIZZA20'),
  (2, 1, 'Buy 2 Get 1 Free', 33, 1, '2026-02-14 08:00:00', NULL),
  (1, 1, 'Free Garlic Bread', 100, 0, '2025-12-01 09:00:00', 'GARLIC100');


-- Saved Discounts
INSERT INTO Saved_Discount (Student_Id, Discount_Id, Saved_At) VALUES
  (1, 1, '2026-03-01 15:00:00'),
  (2, 2, '2026-03-05 11:30:00');


-- Shared Discounts
INSERT INTO Shared_Discount (Sender_Id, Reciever_Id, Discount_Id, Saved_At) VALUES
  (2, 1, 1, '2026-03-02 16:00:00'),
  (1, 3, 2, '2026-03-06 10:00:00');


-- Reports
INSERT INTO Report (Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) VALUES
  (1, 3, 1, 'Listing appears to be expired and misleading', '2026-03-10 09:00:00', 2, 'Listing removed'),
  (2, 1, 1, 'Promo code did not work at checkout', '2026-03-12 14:00:00', 1, NULL);


-- Notifications
INSERT INTO Notification (Student_Id, Notif_Type, Notif_Msg, Sent_Date) VALUES
  (1, 'Deal Alert', 'New pizza deal available near you!', '2026-03-01 08:00:00'),
  (2, 'Report Update', 'Your report has been reviewed.', '2026-03-13 10:00:00'),
  (3, 'Welcome', 'Welcome to edU Save!', '2026-03-15 12:00:00');


-- Listing Analytics
INSERT INTO Listing_Analytics (Disc_Id, View_Count, Save_Count, Redemption_Count) VALUES
  (1, 150, 42, 18),
  (2, 89, 23, 10);


-- Traffic Snapshots
INSERT INTO Traffic_Snapshot (Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) VALUES
  (1, '2026-03-01 00:00:00', '2026-03-07 23:59:59', 'Week 1 March', 320),
  (1, '2026-03-08 00:00:00', '2026-03-14 23:59:59', 'Week 2 March', 275);


-- Competitor Listings
INSERT INTO Competitor_Listing (Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) VALUES
  (1, 'Dominos NEU', 15, 30, 200),
  (1, 'Papa Johns BU', 25, 12, 95);


-- Platform Metrics
INSERT INTO Platform_Metrics (Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) VALUES
  (1, 1250, 47, 3, '2026-03-15 00:00:00'),
  (1, 1280, 52, 1, '2026-03-22 00:00:00');



insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Columbia University', 'Viana do Castelo', 'Viso', -34.5006776, -58.8072561);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('UCLA', 'Porto', 'Vilares', 41.3015266, -8.5820391);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('UCLA', null, 'Nakhon Luang', 14.4759803, 100.6241192);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Columbia University', 'Québec', 'Blainville', 45.7013243, -73.9284855);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('MIT', null, 'Nahura', -6.2291489, 106.8548083);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northeastern University', null, 'Hongchang', 46.6380789, 126.9919589);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northeastern University', null, 'Huangchi', 36.275231, 113.310158);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Columbia University', null, 'Hwado', 37.6523921, 127.3083224);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', 'Ontario', 'Mississauga', 43.6368159, -79.7119419);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('UCLA', null, 'Llusco', -14.34823, -72.121559);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northeastern University', null, 'Purbalingga', -7.3058578, 109.4259114);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Tufts University', null, 'Dueñas', 14.5008343, 121.0485932);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Boston University', 'Lisboa', 'Venda do Valador', 38.927978, -9.238643);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Tufts University', null, 'Ulaandel', 46.36446, 113.577);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Boston University', null, 'Balzan', 35.8965072, 14.4545529);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', null, 'Dalongtan', 39.302809, 99.275837);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Boston University', null, 'Hernando', 35.20105, -91.8318333);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', 'Provence-Alpes-Côte d''Azur', 'Toulon', 43.1283145, 5.9294606);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Columbia University', 'Québec', 'Saint-Ambroise', 48.5556837, -71.3205493);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', 'Oslo', 'Oslo', 59.9278844, 10.7477822);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('NYU', null, 'Sanandaj', 35.3218748, 46.9861647);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northeastern University', null, 'Nazaré', -6.3207152, -47.7834888);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('UCLA', null, 'Sanok', 49.5532749, 22.2110081);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Tufts University', null, 'Skalbmierz', 50.3197113, 20.3992492);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northeastern University', null, 'Santa Rita', -25.7917136, -55.0879338);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', null, 'Sampangbitung', -6.3514294, 105.9141793);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', null, 'Libenge', 3.6489578, 18.6353764);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', 'Nord-Pas-de-Calais', 'Arras', 50.2837307, 2.7425682);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Michigan', null, 'Maní', 4.817986, -72.280702);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', null, 'Uusikaupunki', 60.8110019, 21.4457309);
