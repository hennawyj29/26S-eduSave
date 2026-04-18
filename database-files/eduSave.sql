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
  Receiver_Id INT         NOT NULL,
  Discount_Id INT         NOT NULL,
  Shared_At    DATETIME    NOT NULL,
  PRIMARY KEY (Share_Id),
  CONSTRAINT fk_shared_sender
      FOREIGN KEY (Sender_Id) REFERENCES Student (Student_Id),
  CONSTRAINT fk_shared_reciever
      FOREIGN KEY (Receiver_Id) REFERENCES Student (Student_Id),
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
  Priority     VARCHAR(10)    NOT NULL DEFAULT 1,
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
INSERT INTO Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) VALUES
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


-- University Data
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northeastern University', 'MA', 'Boston', 42.3398, -71.0892);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Boston University', 'MA', 'Boston', 42.3505, -71.1054);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('MIT', 'MA', 'Cambridge', 42.3601, -71.0942);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Harvard University', 'MA', 'Cambridge', 42.3770, -71.1167);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Tufts University', 'MA', 'Medford', 42.4075, -71.1190);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('UCLA', 'CA', 'Los Angeles', 34.0689, -118.4452);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('USC', 'CA', 'Los Angeles', 34.0224, -118.2851);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('UC Berkeley', 'CA', 'Berkeley', 37.8724, -122.2595);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Columbia University', 'NY', 'New York', 40.8075, -73.9626);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('NYU', 'NY', 'New York', 40.7295, -73.9965);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Cornell University', 'NY', 'Ithaca', 42.4534, -76.4735);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Michigan', 'MI', 'Ann Arbor', 42.2808, -83.7430);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Chicago', 'IL', 'Chicago', 41.7886, -87.5987);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Northwestern University', 'IL', 'Evanston', 42.0565, -87.6753);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Texas at Austin', 'TX', 'Austin', 30.2849, -97.7341);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Rice University', 'TX', 'Houston', 29.7174, -95.4018);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Washington', 'WA', 'Seattle', 47.6553, -122.3035);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Minnesota', 'MN', 'Minneapolis', 44.9727, -93.2354);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Arizona State University', 'AZ', 'Tempe', 33.4242, -111.9281);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of North Carolina', 'NC', 'Chapel Hill', 35.9132, -79.0558);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Duke University', 'NC', 'Durham', 36.0014, -78.9382);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Georgia Tech', 'GA', 'Atlanta', 33.7756, -84.3963);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Vanderbilt University', 'TN', 'Nashville', 36.1447, -86.8027);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Virginia', 'VA', 'Charlottesville', 38.0293, -78.4767);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Penn State University', 'PA', 'State College', 40.7982, -77.8599);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Pittsburgh', 'PA', 'Pittsburgh', 40.4444, -79.9608);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Ohio State University', 'OH', 'Columbus', 40.0067, -83.0305);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Illinois', 'IL', 'Champaign', 40.1020, -88.2272);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Tulane University', 'LA', 'New Orleans', 29.9384, -90.1200);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Florida', 'FL', 'Gainesville', 29.6436, -82.3549);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Miami', 'FL', 'Coral Gables', 25.7213, -80.2787);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('Syracuse University', 'NY', 'Syracuse', 43.0481, -76.1474);
insert into University (Uni_Name, State, City, Uni_Lat, Uni_Lng) values ('University of Arizona', 'AZ', 'Tucson', 32.2319, -110.9501);

--- Category Data
insert into Category (Category_Name) values ('Travel');
insert into Category (Category_Name) values ('Books');
insert into Category (Category_Name) values ('Sports');
insert into Category (Category_Name) values ('Books');
insert into Category (Category_Name) values ('Health');
insert into Category (Category_Name) values ('Books');
insert into Category (Category_Name) values ('Books');
insert into Category (Category_Name) values ('Clothing');
insert into Category (Category_Name) values ('Beauty');
insert into Category (Category_Name) values ('Technology');
insert into Category (Category_Name) values ('Food');
insert into Category (Category_Name) values ('Clothing');
insert into Category (Category_Name) values ('Electronics');
insert into Category (Category_Name) values ('Technology');
insert into Category (Category_Name) values ('Technology');
insert into Category (Category_Name) values ('Electronics');
insert into Category (Category_Name) values ('Food');
insert into Category (Category_Name) values ('Electronics');
insert into Category (Category_Name) values ('Electronics');
insert into Category (Category_Name) values ('Food');
insert into Category (Category_Name) values ('Travel');
insert into Category (Category_Name) values ('Electronics');
insert into Category (Category_Name) values ('Food');
insert into Category (Category_Name) values ('Health');
insert into Category (Category_Name) values ('Technology');
insert into Category (Category_Name) values ('Entertainment');

-- Admin Data 
insert into Admin (Admin_Name, Admin_Role) values ('Addison Verdie', 'Data Analyst');
insert into Admin (Admin_Name, Admin_Role) values ('Darline Scullard', 'Data Analyst');
insert into Admin (Admin_Name, Admin_Role) values ('Flossi Brodeau', 'Data Analyst');
insert into Admin (Admin_Name, Admin_Role) values ('Franzen Anfusso', 'Support Agent');
insert into Admin (Admin_Name, Admin_Role) values ('Aguste Millen', 'Data Analyst');
insert into Admin (Admin_Name, Admin_Role) values ('Yehudit McBain', 'Operations Manager');
insert into Admin (Admin_Name, Admin_Role) values ('Cristie Kirrage', 'Support Agent');
insert into Admin (Admin_Name, Admin_Role) values ('Hesther Lacasa', 'System Admin');
insert into Admin (Admin_Name, Admin_Role) values ('Jeanie Pollastro', 'System Admin');
insert into Admin (Admin_Name, Admin_Role) values ('Grove Clink', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Joeann Tockell', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Brandais McCaighey', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Coop Workman', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Toby MacDermot', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Ware Aronow', 'System Admin');
insert into Admin (Admin_Name, Admin_Role) values ('Hedwiga Radolf', 'Data Analyst');
insert into Admin (Admin_Name, Admin_Role) values ('Hestia Grishukhin', 'Operations Manager');
insert into Admin (Admin_Name, Admin_Role) values ('Kym Kinnoch', 'Support Agent');
insert into Admin (Admin_Name, Admin_Role) values ('Melinde Pelfer', 'Support Agent');
insert into Admin (Admin_Name, Admin_Role) values ('Chicky Nurse', 'System Admin');
insert into Admin (Admin_Name, Admin_Role) values ('Pauletta Bonhill', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Rosalinda Zum Felde', 'System Admin');
insert into Admin (Admin_Name, Admin_Role) values ('Xever Breslin', 'Operations Manager');
insert into Admin (Admin_Name, Admin_Role) values ('Lucie Figure', 'Support Agent');
insert into Admin (Admin_Name, Admin_Role) values ('Paco Matveiko', 'Operations Manager');
insert into Admin (Admin_Name, Admin_Role) values ('Lenette Berrisford', 'Content Moderator');
insert into Admin (Admin_Name, Admin_Role) values ('Lynette Aldersley', 'Data Analyst');
insert into Admin (Admin_Name, Admin_Role) values ('Erich Sandal', 'System Admin');
insert into Admin (Admin_Name, Admin_Role) values ('Melicent Bryning', 'Support Agent');
insert into Admin (Admin_Name, Admin_Role) values ('Herold Crankshaw', 'System Admin');

-- Business Data
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Campus Cuts', 'www.campuscuts.com', '132 College Ave, Boston, MA 02115', 1, '2025-01-10 09:00:00', true, 42.3736, -71.1097);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Brew & Study Cafe', 'www.brewandstudycafe.com', '45 Figueroa St, Los Angeles, CA 90007', 1, '2025-02-03 10:30:00', true, 34.0224, -118.2851);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('The Protein Bar', 'www.theproteinbar.com', '8 E 59th St, Chicago, IL 60637', 1, '2025-03-15 11:00:00', true, 41.7943, -87.5907);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('NorthEnd Pizza Co.', 'www.northendpizzaco.com', '210 W College Ave, State College, PA 16801', 1, '2025-01-22 08:30:00', true, 40.7993, -77.8600);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('FitZone Gym', 'www.fitzoneaustin.com', '2415 Guadalupe St, Austin, TX 78705', 1, '2025-04-08 07:45:00', true, 30.2849, -97.7341);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Ink & Ideas Print Shop', 'www.inkandideas.com', '174 E Franklin St, Chapel Hill, NC 27514', 1, '2025-02-17 13:00:00', false, 35.9132, -79.0558);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Smoothie Spot', 'www.smoothiespot.com', '4300 15th Ave NE, Seattle, WA 98105', 1, '2025-05-01 08:00:00', true, 47.6553, -122.3035);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Laced Up Sneakers', 'www.lacedupsneakers.com', '612 Washington Ave SE, Minneapolis, MN 55414', 1, '2025-03-29 10:00:00', true, 44.9727, -93.2354);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Auto Express Service', 'www.autoexpresstempe.com', '802 S Mill Ave, Tempe, AZ 85281', 0, '2024-06-14 09:15:00', false, 33.4242, -111.9281);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('The Nail Studio', 'www.thenailstudiohou.com', '3810 Main St, Houston, TX 77002', 1, '2024-07-20 11:30:00', true, 29.7174, -95.4018);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Backpack & Beyond', 'www.backpackandbeyond.com', '512 E Liberty St, Ann Arbor, MI 48104', 1, '2024-08-05 14:00:00', true, 42.2808, -83.7430);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Golden Bowl', 'www.goldenbowlberkeley.com', '2120 Oxford St, Berkeley, CA 94704', 1, '2024-09-11 12:00:00', true, 37.8694, -122.2595);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Escape the Room', 'www.escapetheroomcolumbus.com', '55 E 11th Ave, Columbus, OH 43201', 1, '2024-10-03 15:00:00', true, 39.9612, -82.9988);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Sunset Yoga Studio', 'www.sunsetyoganashville.com', '2100 West End Ave, Nashville, TN 37235', 1, '2024-11-18 07:30:00', true, 36.1447, -86.8027);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Pho & Friends', 'www.phoandfriends.com', '1500 University Ave, Charlottesville, VA 22903', 1, '2024-12-02 11:00:00', true, 38.0293, -78.4767);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Green Leaf Salads', 'www.greenleafsalads.com', '601 S Wright St, Champaign, IL 61820', 0, '2024-05-27 09:45:00', false, 40.1020, -88.2272);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Campus Threads', 'www.campusthreads.com', '88 5th St NW, Atlanta, GA 30332', 1, '2025-01-15 10:15:00', true, 33.7756, -84.3963);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Hub Burger Bar', 'www.hubburgernola.com', '6800 St Charles Ave, New Orleans, LA 70118', 1, '2025-02-28 12:30:00', true, 29.9511, -90.0715);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Pressed Juice Co.', 'www.pressedjuiceco.com', '1600 S University Dr, Fort Worth, TX 76107', 1, '2025-03-10 08:00:00', true, 32.7357, -97.1081);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Fenway Frames Eyewear', 'www.fenwayframes.com', '900 S Crouse Ave, Syracuse, NY 13210', 1, '2025-04-22 13:30:00', false, 43.0481, -76.1474);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('The Late Night Slice', 'www.thelatenightslice.com', '262 E 11th Ave, Columbus, OH 43201', 1, '2025-05-14 16:00:00', true, 39.9848, -82.9850);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Charge Up Smoothies', 'www.chargeupsmoothies.com', '200 W Chimes St, Baton Rouge, LA 70803', 1, '2025-06-01 07:00:00', true, 30.4133, -91.1800);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Bookworm Supplies', 'www.bookwormsupplies.com', '350 Huntington Ave, Boston, MA 02115', 0, '2024-07-09 10:00:00', false, 42.3601, -71.0942);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Waves Car Wash', 'www.wavescarwash.com', '400 S Highland St, Memphis, TN 38111', 1, '2024-08-23 09:00:00', true, 35.1495, -90.0490);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Sushi Spot', 'www.sushistspot.com', '155 S Market St, San Jose, CA 95113', 1, '2024-09-30 11:45:00', true, 37.3382, -121.8863);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Iron & Lift Fitness', 'www.ironandliftpitt.com', '3990 Forbes Ave, Pittsburgh, PA 15213', 1, '2024-10-15 06:30:00', true, 40.4406, -79.9959);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Glow Spa & Wellness', 'www.glowspacharlotte.com', '9201 University City Blvd, Charlotte, NC 28223', 1, '2024-11-04 14:00:00', true, 35.2271, -80.8431);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Quick Stitch Tailor', 'www.quickstitchdsm.com', '2900 University Ave, Des Moines, IA 50311', 0, '2024-04-17 10:30:00', false, 41.5868, -93.6250);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Taco Libre', 'www.tacolibretucson.com', '1200 E University Blvd, Tucson, AZ 85721', 1, '2024-12-19 12:00:00', true, 32.2319, -110.9501);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('The Study Lounge', 'www.thestudylounge.com', '85 S Prospect St, Burlington, VT 05405', 1, '2025-01-08 09:30:00', true, 44.4759, -73.2121);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Crimson Cuts Barbershop', 'www.crimsoncutsmd.com', '7814 Baltimore Ave, College Park, MD 20742', 1, '2025-02-11 08:00:00', true, 38.9897, -76.9378);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Bowled Over', 'www.bowledoverathens.com', '195 E Broad St, Athens, GA 30601', 1, '2025-03-05 15:00:00', true, 33.9741, -83.3736);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Coastal Surf & Skate', 'www.coastalsurftampa.com', '4202 E Fowler Ave, Tampa, FL 33620', 0, '2024-06-30 11:00:00', false, 27.9506, -82.4572);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Fuel Burritos', 'www.fuelburritos.com', '120 Washington St, Hoboken, NJ 07030', 1, '2025-04-03 10:00:00', true, 40.7282, -74.0776);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Matcha & More', 'www.matchaandmore.com', '39600 Fremont Blvd, Fremont, CA 94538', 1, '2025-05-19 08:30:00', true, 37.5485, -121.9886);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Kicks & Fits', 'www.kicksandfits.com', '1 Chapel St, New Haven, CT 06511', 1, '2025-06-07 13:00:00', true, 41.3083, -72.9279);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Speedy Lube & Tire', 'www.speedylubeknox.com', '1600 Cumberland Ave, Knoxville, TN 37916', 1, '2024-07-14 07:00:00', true, 35.9606, -83.9207);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Cozy Ramen House', 'www.cozyramentacoma.com', '1500 Pacific Ave, Tacoma, WA 98402', 1, '2024-08-28 12:00:00', true, 47.2529, -122.4443);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Acai & Co.', 'www.acaiandco.com', '1300 SW 1st St, Miami, FL 33135', 1, '2024-09-16 09:00:00', true, 25.7617, -80.1918);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('The Photo Booth Studio', 'www.photboothstudio.com', '2100 Hillsborough St, Raleigh, NC 27607', 0, '2024-03-22 14:30:00', false, 36.0014, -78.9382);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('SoCal Sports', 'www.socalsports.com', '825 S Figueroa St, Los Angeles, CA 90017', 1, '2025-03-10 09:00:00', true, 34.0443, -118.2598);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Bruin Athletics Supply', 'www.bruinathletics.com', '1065 Gayley Ave, Los Angeles, CA 90024', 1, '2025-04-15 10:00:00', true, 34.0617, -118.4488);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Trojan Fitness Gear', 'www.trojanfitness.com', '3210 S Hoover St, Los Angeles, CA 90089', 1, '2025-05-20 11:00:00', true, 34.0195, -118.2854);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('Venice Beach Sports Co.', 'www.venicebeachsports.com', '1800 Ocean Front Walk, Venice, CA 90291', 1, '2025-06-01 08:30:00', true, 33.9850, -118.4695);
insert into Business (Biz_Name, Website, Address, Account_Status, Joined_Date, Verified_Status, Biz_Lat, Biz_Lng) values ('LA Campus Rec', 'www.lacampusrec.com', '555 N Vermont Ave, Los Angeles, CA 90004', 1, '2025-07-12 09:30:00', false, 34.0785, -118.2901);

-- Student Data
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (1, 'Arjun', 'Patel', 'arjun_p', 'patel.arj@northeastern.edu', 'International', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (2, 'Mark', 'Smith', 'marksmith', 'smith.mark@bu.edu', 'Domestic', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (1, 'Emily', 'Chen', 'echen', 'chen.em@northeastern.edu', 'Domestic', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (3, 'Sofia', 'Nguyen', 'sofi_ng', 'nguyen.sof@ucla.edu', 'International', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (4, 'James', 'Okafor', 'jokafor', 'okafor.j@umich.edu', 'Domestic', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (5, 'Priya', 'Sharma', 'priya_s', 'sharma.pri@utexas.edu', 'International', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (6, 'Liam', 'Torres', 'liamtorres', 'torres.li@unc.edu', 'Domestic', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (7, 'Aisha', 'Johnson', 'aishaj', 'johnson.ai@uw.edu', 'Domestic', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (8, 'Kevin', 'Park', 'kpark22', 'park.kev@umn.edu', 'International', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (9, 'Maya', 'Robinson', 'maya_rob', 'robinson.may@asu.edu', 'Domestic', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (10, 'Diego', 'Alvarez', 'diegoa', 'alvarez.di@rice.edu', 'International', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (4, 'Hannah', 'Lee', 'hlee04', 'lee.han@umich.edu', 'Domestic', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (11, 'Omar', 'Hassan', 'ohassan', 'hassan.om@berkeley.edu', 'International', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (12, 'Chloe', 'Martin', 'chloe_m', 'martin.ch@osu.edu', 'Domestic', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (13, 'Ethan', 'Williams', 'ewill13', 'williams.et@vanderbilt.edu', 'Domestic', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (14, 'Fatima', 'Ali', 'fatima_a', 'ali.fat@virginia.edu', 'International', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (5, 'Noah', 'Davis', 'ndavis', 'davis.no@utexas.edu', 'Domestic', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (15, 'Zoe', 'Kim', 'zoekim', 'kim.zoe@tulane.edu', 'Domestic', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (16, 'Raj', 'Iyer', 'raj_iy', 'iyer.raj@tcu.edu', 'International', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (17, 'Isabelle', 'Dupont', 'isadupont', 'dupont.is@syracuse.edu', 'International', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (3, 'Marcus', 'Brown', 'mbrown', 'brown.mar@ucla.edu', 'Domestic', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (18, 'Mei', 'Zhang', 'meizhang', 'zhang.mei@lsu.edu', 'International', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (19, 'Tyler', 'Jackson', 'tjack19', 'jackson.ty@memphis.edu', 'Domestic', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (20, 'Nadia', 'Petrov', 'nadiap', 'petrov.na@sjsu.edu', 'International', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (21, 'Brandon', 'Scott', 'bscott', 'scott.br@pitt.edu', 'Domestic', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (22, 'Alicia', 'Gomez', 'agomez', 'gomez.al@uncc.edu', 'Domestic', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (6, 'Jin', 'Wu', 'jinwu', 'wu.jin@unc.edu', 'International', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (23, 'Olivia', 'Reed', 'oreed', 'reed.ol@arizona.edu', 'Domestic', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (24, 'Samuel', 'Osei', 'sosei', 'osei.sa@uvm.edu', 'International', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (25, 'Rachel', 'Nguyen', 'rnguyen', 'nguyen.ra@umd.edu', 'Domestic', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (26, 'Andre', 'Mitchell', 'andrem', 'mitchell.an@uga.edu', 'Domestic', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (27, 'Yuna', 'Choi', 'yunachoi', 'choi.yu@usf.edu', 'International', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (28, 'Connor', 'Walsh', 'cwalsh', 'walsh.co@stevens.edu', 'Domestic', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (29, 'Leila', 'Ahmadi', 'lahmadi', 'ahmadi.le@yale.edu', 'International', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (30, 'Chris', 'Taylor', 'ctaylor', 'taylor.ch@utk.edu', 'Domestic', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (31, 'Amara', 'Diallo', 'amarad', 'diallo.am@tacomacc.edu', 'International', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (32, 'Jake', 'Evans', 'jevans', 'evans.ja@miami.edu', 'Domestic', 2027, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (33, 'Tanya', 'Flores', 'tflores', 'flores.ta@ncsu.edu', 'Domestic', 2025, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (2, 'Victor', 'Huang', 'vhuang', 'huang.vi@bu.edu', 'International', 2028, 0);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (11, 'Sara', 'O''Brien', 'sobrien', 'obrien.sa@berkeley.edu', 'Domestic', 2026, 1);
insert into Student (Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (12, 'Kwame', 'Asante', 'kasante', 'asante.kw@osu.edu', 'International', 2027, 1);

-- Business_Owner Data
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (3, 25, 29, 'Nancy Lundbeck', 'nlundbeck@yahoo.com', '100-144-7062');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (4, 2, 27, 'Norine Boumphrey', 'nboumphrey@outlook.com', '621-876-3960');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (5, 38, 12, 'Natassia Iggo', 'niggo@gmail.com', '378-855-9295');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (6, 14, 21, 'Agnese Schollick', 'aschollick@yahoo.com', '511-441-3606');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (7, 33, 7, 'Steffen Martygin', 'smartygin@outlook.com', '250-193-6626');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (8, 9, 2, 'Josefa Rous', 'jrous@gmail.com', '401-720-7049');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (9, 21, 18, 'Toni Gasnoll', 'tgasnoll@yahoo.com', '400-931-9701');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (10, 39, 10, 'Huberto Jimmes', 'hjimmes@gmail.com', '219-613-0794');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (11, 40, 23, 'Hugues Breston', 'hbreston@outlook.com', '384-553-8325');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (12, 13, 12, 'Genevieve Killgus', 'gkillgus@gmail.com', '127-278-8119');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (13, 28, 33, 'Timi McGiffie', 'tmcgiffie@yahoo.com', '954-468-2330');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (14, 25, 28, 'Celie Keggins', 'ckeggins@gmail.com', '428-508-5356');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (15, 20, 11, 'Daisi Kobke', 'dkobke@outlook.com', '791-258-7249');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (16, 6, 32, 'Lilith Eisak', 'leisak@gmail.com', '517-217-4714');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (17, 10, 16, 'Lorant Etock', 'letock@yahoo.com', '530-307-5433');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (18, 31, 32, 'Dara Kesterton', 'dkesterton@gmail.com', '916-183-5168');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (19, 1, 20, 'Alis Gerleit', 'agerleit@outlook.com', '378-236-3883');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (20, 32, 8, 'Orelle Barniss', 'obarniss@gmail.com', '825-843-9371');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (21, 36, 26, 'Cordy Heinritz', 'cheinritz@yahoo.com', '511-220-6728');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (22, 22, 33, 'Greggory Boxer', 'gboxer@gmail.com', '301-646-8028');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (23, 27, 3, 'Isac Crum', 'icrum@outlook.com', '153-735-1506');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (24, 16, 15, 'Eugene Baterip', 'ebaterip@gmail.com', '448-188-3709');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (25, 4, 32, 'Brok Mesias', 'bmesias@yahoo.com', '984-517-4031');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (26, 35, 19, 'Hilde Tomaszczyk', 'htomaszczyk@gmail.com', '901-324-0945');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (27, 8, 28, 'Nettie Scolts', 'nscolts@outlook.com', '418-901-3186');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (28, 29, 9, 'Graehme Lillicrap', 'glillicrap@gmail.com', '198-333-1871');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (29, 11, 29, 'Boy Rodgman', 'brodgman@yahoo.com', '315-888-3406');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (30, 23, 5, 'Sutton Gilligan', 'sgilligan@gmail.com', '482-764-1667');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (31, 34, 3, 'Morgan McKinnon', 'mmckinnon@outlook.com', '313-396-8868');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (32, 18, 9, 'Bartie Ryburn', 'bryburn@gmail.com', '979-137-3323');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (33, 7, 25, 'Marji Shyres', 'mshyres@yahoo.com', '318-814-3608');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (34, 26, 14, 'Marji Littlepage', 'mlittlepage@gmail.com', '613-122-2669');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (35, 37, 11, 'Heath Glasner', 'hglasner@outlook.com', '217-651-3057');


-- Discounts 
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (1, 1, '20% Off Large Pizzas', 20, true, '2026-01-10 09:00:00', 'PIZZA20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (2, 1, 'Buy 2 Get 1 Free Burgers', 33, true, '2026-02-14 08:00:00', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (3, 1, 'Free Garlic Bread with Any Order', 0, false, '2025-12-01 09:00:00', 'GARLIC100');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (4, 2, '15% Off All Textbooks', 15, true, '2026-01-15 10:00:00', 'BOOKS15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (5, 2, 'Student Meal Deal - $5 Off', 5, true, '2026-02-01 11:00:00', 'MEAL5');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (6, 3, '10% Off First Haircut', 10, true, '2026-01-20 09:30:00', 'FIRSTCUT10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (7, 3, 'Half-Price Blowout Tuesdays', 50, true, '2026-03-01 08:00:00', 'BLOWOUT50');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (8, 4, '$20 Off Any Gym Membership', 20, true, '2026-02-10 07:00:00', 'GYM20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (9, 4, 'Free Week Trial - Yoga Studio', 100, false, '2025-11-15 08:00:00', 'YOGAFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (10, 5, '25% Off Vintage Tees', 25, true, '2026-03-05 13:00:00', 'TEES25');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (11, 5, 'Spend $50 Save $10', 10, true, '2026-01-25 14:00:00', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (12, 6, '$15 Off Oil Change', 15, true, '2026-02-20 08:30:00', 'OIL15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (13, 6, 'Free Tire Rotation with Service', 0, true, '2026-03-10 09:00:00', 'TIREFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (14, 7, '30% Off All Smoothies', 30, true, '2026-02-28 07:30:00', 'SMOOTH30');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (15, 7, 'Buy 1 Juice Get 1 50% Off', 50, false, '2025-12-20 10:00:00', 'JUICE50');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (16, 8, '20% Off Movie Tickets Online', 20, true, '2026-01-05 15:00:00', 'MOVIE20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (17, 8, 'Tuesday $5 Admission', 5, true, '2026-03-15 12:00:00', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (18, 9, '$10 Off Print Orders Over $30', 10, true, '2026-02-05 11:30:00', 'PRINT10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (19, 9, 'Free Lamination with Any Order', 0, false, '2025-11-01 09:00:00', 'LAMIFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (20, 10, '40% Off Seasonal Menu Items', 40, true, '2026-03-20 17:00:00', 'SEASON40');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (21, 1, 'Free Delivery on Orders Over $15', 0, true, '2026-01-03 08:00:00', 'DELIVER0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (22, 2, '10% Off School Supplies', 10, true, '2026-01-06 10:00:00', 'SUPPLY10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (23, 3, '$8 Off Any Spa Treatment', 8, true, '2026-01-09 11:00:00', 'SPA8');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (24, 4, '20% Off Fitness Classes', 20, false, '2026-01-12 13:00:00', 'FIT20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (25, 5, 'Buy 2 Get 1 Free on Accessories', 33, true, '2026-01-18 14:00:00', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (26, 6, 'Free Car Wash with Oil Change', 0, true, '2026-01-22 09:00:00', 'WASH0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (27, 7, '15% Off Acai Bowls', 15, true, '2026-01-28 08:30:00', 'ACAI15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (28, 8, '$5 Off Escape Room Bookings', 5, true, '2026-02-02 10:00:00', 'ESCAPE5');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (29, 9, '20% Off Business Card Orders', 20, false, '2026-02-06 11:00:00', 'BIZ20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (30, 10, 'Happy Hour 25% Off Drinks', 25, true, '2026-02-11 16:00:00', 'HAPPY25');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (31, 1, '$3 Off Any Sandwich', 3, true, '2026-02-14 07:30:00', 'SAND3');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (32, 2, 'Free Notebook with $25 Purchase', 0, true, '2026-02-18 10:30:00', 'NOTE0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (33, 3, '30% Off Nail Services', 30, false, '2026-02-22 12:00:00', 'NAIL30');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (34, 4, 'First Month Gym Free', 100, true, '2026-02-26 07:00:00', 'GYMFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (35, 5, '20% Off Winter Jackets', 20, false, '2026-03-01 13:00:00', 'JACKET20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (36, 6, '$10 Off Brake Inspection', 10, true, '2026-03-04 08:00:00', 'BRAKE10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (37, 7, 'Free Protein Add-On with Smoothie', 0, true, '2026-03-07 09:00:00', 'PROTEIN0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (38, 8, '15% Off Mini Golf for Groups', 15, true, '2026-03-11 11:00:00', 'GOLF15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (39, 9, '$20 Off Custom T-Shirt Orders', 20, true, '2026-03-16 14:00:00', 'SHIRT20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (40, 10, '10% Off Brunch Menu', 10, true, '2026-03-22 10:00:00', 'BRUNCH10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (2, 6, '20% Off All Sporting Goods', 20, true, '2026-01-05 09:00:00', 'SPORT20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (6, 6, '15% Off Yoga Mats and Gear', 15, true, '2026-01-12 10:00:00', 'YOGA15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (7, 6, 'Free Water Bottle with $40 Purchase', 0, true, '2026-01-18 11:00:00', 'BOTTLE0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (2, 6, '10% Off Rock Climbing Gear', 10, true, '2026-01-25 08:30:00', 'CLIMB10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (6, 6, '25% Off Student Surf Rentals', 25, true, '2026-02-01 09:00:00', 'SURF25');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (7, 6, '$10 Off Skateboard Decks', 10, true, '2026-02-08 13:00:00', 'SKATE10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (2, 6, '30% Off Running Shoes', 30, false, '2026-02-15 10:30:00', 'RUN30');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (6, 6, 'Buy 1 Get 1 50% Off Tennis Balls', 50, true, '2026-02-22 11:00:00', 'TENNIS50');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (7, 6, '20% Off Gym Bags and Backpacks', 20, true, '2026-03-01 08:00:00', 'GYMBAG20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (2, 6, 'Free Fitness Class with Equipment Purchase', 0, true, '2026-03-10 09:30:00', 'FITCLASS0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (41, 6, '20% Off All Sporting Goods', 20, true, '2026-01-05 09:00:00', 'SPORT20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (42, 6, '15% Off Yoga Mats and Gear', 15, true, '2026-01-12 10:00:00', 'YOGA15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (43, 6, 'Free Water Bottle with $40 Purchase', 0, true, '2026-01-18 11:00:00', 'BOTTLE0');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (44, 6, '25% Off Student Surf Rentals', 25, true, '2026-02-01 09:00:00', 'SURF25');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (45, 6, '$10 Off Skateboard Decks', 10, true, '2026-02-08 13:00:00', 'SKATE10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (41, 6, '30% Off Running Shoes', 30, false, '2026-02-15 10:30:00', 'RUN30');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (42, 6, 'Buy 1 Get 1 50% Off Tennis Balls', 50, true, '2026-02-22 11:00:00', 'TENNIS50');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (43, 6, '20% Off Gym Bags and Backpacks', 20, true, '2026-03-01 08:00:00', 'GYMBAG20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (44, 6, '10% Off Rock Climbing Gear', 10, true, '2026-03-08 09:00:00', 'CLIMB10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (45, 6, 'Free Fitness Class with Equipment Purchase', 0, true, '2026-03-10 09:30:00', 'FITCLASS0');

-- Saved_Discount
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (1, 1, '2026-03-01 15:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (2, 2, '2026-03-05 11:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (3, 5, '2026-01-07 09:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (4, 8, '2026-01-14 13:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (5, 3, '2026-01-19 10:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (6, 12, '2026-01-23 14:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (7, 7, '2026-01-26 08:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (8, 15, '2026-02-01 12:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (9, 4, '2026-02-10 09:45:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (10, 10, '2026-02-11 11:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (11, 6, '2026-02-15 16:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (12, 18, '2026-02-19 10:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (13, 9, '2026-02-20 13:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (14, 14, '2026-02-25 09:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (15, 2, '2026-02-27 11:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (16, 20, '2026-03-01 14:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (17, 11, '2026-03-09 08:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (18, 16, '2026-03-12 10:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (19, 13, '2026-03-18 12:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (20, 17, '2026-03-28 15:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (21, 22, '2026-01-05 09:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (22, 25, '2026-01-10 11:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (23, 21, '2026-01-13 13:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (24, 28, '2026-01-17 10:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (25, 31, '2026-01-21 14:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (26, 24, '2026-01-25 09:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (27, 34, '2026-01-29 11:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (28, 27, '2026-02-03 08:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (29, 33, '2026-02-06 12:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (30, 36, '2026-02-10 15:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (31, 23, '2026-02-13 10:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (32, 39, '2026-02-17 09:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (33, 26, '2026-02-21 13:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (34, 29, '2026-02-24 11:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (35, 32, '2026-02-28 08:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (36, 35, '2026-03-03 14:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (37, 38, '2026-03-08 10:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (38, 30, '2026-03-13 12:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (39, 37, '2026-03-19 09:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (40, 40, '2026-03-25 16:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (1, 22, '2026-01-06 10:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (5, 30, '2026-01-20 11:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (9, 25, '2026-02-04 09:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (13, 38, '2026-02-16 14:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (17, 21, '2026-02-23 10:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (22, 14, '2026-03-02 13:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (28, 33, '2026-03-07 08:30:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (34, 7, '2026-03-14 11:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (38, 19, '2026-03-22 15:00:00');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (40, 28, '2026-03-30 09:30:00');


-- Shared_Discount
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (2, 1, 1, '2026-03-02 16:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (1, 3, 2, '2026-03-06 10:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (4, 2, 5, '2026-01-08 09:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (3, 5, 8, '2026-01-15 11:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (6, 4, 3, '2026-02-01 14:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (5, 7, 12, '2026-02-09 08:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (8, 6, 7, '2026-02-14 12:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (7, 9, 15, '2026-02-20 10:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (10, 8, 4, '2026-02-25 09:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (9, 11, 10, '2026-03-01 13:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (12, 10, 6, '2026-03-05 11:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (11, 13, 18, '2026-03-08 08:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (14, 12, 9, '2026-03-11 14:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (13, 15, 14, '2026-03-14 10:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (16, 14, 2, '2026-03-17 09:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (15, 17, 20, '2026-03-19 12:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (18, 16, 11, '2026-03-21 15:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (17, 19, 16, '2026-03-23 11:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (20, 18, 13, '2026-03-26 09:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (19, 20, 17, '2026-03-29 14:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (3, 21, 22, '2026-01-04 10:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (7, 22, 25, '2026-01-09 08:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (11, 23, 28, '2026-01-16 13:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (15, 24, 31, '2026-01-21 11:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (19, 25, 34, '2026-01-27 09:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (22, 26, 21, '2026-02-03 14:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (24, 27, 27, '2026-02-07 10:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (26, 28, 33, '2026-02-12 12:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (28, 29, 36, '2026-02-17 08:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (30, 20, 39, '2026-02-22 11:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (21, 31, 23, '2026-02-26 15:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (23, 32, 26, '2026-03-02 09:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (25, 33, 29, '2026-03-06 13:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (27, 34, 32, '2026-03-10 10:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (29, 35, 35, '2026-03-13 11:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (31, 36, 38, '2026-03-17 08:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (33, 37, 24, '2026-03-20 14:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (35, 38, 30, '2026-03-24 09:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (37, 39, 37, '2026-03-27 12:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (39, 40, 40, '2026-03-31 10:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (2, 38, 30, '2026-01-08 11:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (6, 17, 21, '2026-01-19 09:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (10, 33, 14, '2026-02-05 14:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (14, 22, 38, '2026-02-13 10:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (18, 40, 25, '2026-02-19 08:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (23, 9, 33, '2026-02-28 13:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (32, 5, 7, '2026-03-04 11:30:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (36, 14, 28, '2026-03-09 09:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (38, 26, 19, '2026-03-23 15:00:00');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (40, 11, 35, '2026-03-28 10:00:00');


-- Report
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (3, 1, 35, 3, 'The discount did not apply at register', '2025-10-24 09:00:00', 'high', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (4, 13, 39, 2, 'Full price charged at checkout', '2026-01-26 14:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (5, 5, 20, 3, 'Incorrect pricing at checkout', '2025-08-29 10:30:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (6, 7, 31, 2, 'Incorrect pricing at checkout', '2025-09-14 08:00:00', 'low', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (7, 2, 33, 3, 'The discount did not apply', '2025-10-19 13:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (8, 4, 19, 3, 'The discount did not apply', '2026-01-07 09:30:00', 'low', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (9, 38, 11, 2, 'The discount did not apply', '2025-12-13 11:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (10, 9, 24, 3, 'The discount did not apply', '2025-04-24 14:30:00', 'high', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (11, 34, 31, 2, 'The discount did not apply', '2025-05-20 10:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (12, 30, 21, 3, 'The discount did not apply', '2025-12-20 09:00:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (13, 17, 35, 2, 'Incorrect pricing at checkout', '2026-03-11 13:30:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (14, 22, 33, 3, 'The discount did not apply', '2025-04-23 11:00:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (15, 8, 2, 2, 'Full price charged at checkout', '2025-07-20 08:30:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (16, 1, 27, 3, 'The discount did not apply', '2025-05-11 10:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (17, 10, 38, 2, 'Incorrect pricing at checkout', '2025-09-08 14:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (18, 16, 35, 3, 'Incorrect pricing at checkout', '2026-03-16 09:30:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (19, 24, 18, 2, 'Incorrect pricing at checkout', '2025-09-18 11:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (20, 18, 27, 3, 'Full price charged at checkout', '2025-05-28 13:00:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (21, 7, 27, 2, 'Full price charged at checkout', '2026-02-27 10:30:00', 'high', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (22, 39, 19, 3, 'Full price charged at checkout', '2025-08-24 08:00:00', 'high', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (23, 39, 34, 2, 'The discount did not apply', '2026-01-22 14:00:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (24, 40, 29, 3, 'Incorrect pricing at checkout', '2025-11-16 09:00:00', 'high', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (25, 31, 21, 2, 'Full price charged at checkout', '2025-10-10 11:30:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (26, 36, 34, 3, 'Incorrect pricing at checkout', '2026-02-20 13:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (27, 31, 23, 2, 'Incorrect pricing at checkout', '2025-04-14 10:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (28, 34, 35, 3, 'Full price charged at checkout', '2026-02-04 08:30:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (29, 26, 33, 2, 'Incorrect pricing at checkout', '2026-04-03 14:30:00', 'high', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (30, 33, 26, 3, 'The discount did not apply', '2025-07-25 09:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (31, 31, 38, 2, 'Full price charged at checkout', '2025-10-25 11:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (32, 33, 22, 3, 'Full price charged at checkout', '2025-12-26 13:00:00', 'low', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (33, 34, 39, 2, 'Incorrect pricing at checkout', '2025-06-24 10:30:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (34, 21, 27, 3, 'Full price charged at checkout', '2026-04-06 08:00:00', 'high', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (35, 10, 33, 2, 'Full price charged at checkout', '2025-10-09 14:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (36, 39, 35, 3, 'Full price charged at checkout', '2025-11-22 09:30:00', 'high', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (37, 38, 33, 2, 'Full price charged at checkout', '2025-10-11 11:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (38, 10, 13, 3, 'Full price charged at checkout', '2026-03-12 13:30:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (39, 38, 34, 2, 'Full price charged at checkout', '2025-06-10 08:00:00', 'low', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (40, 36, 26, 3, 'The discount did not apply', '2025-11-14 10:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (41, 34, 35, 2, 'Incorrect pricing at checkout', '2025-08-01 14:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (42, 20, 23, 3, 'Full price charged at checkout', '2025-10-30 09:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (43, 12, 36, 2, 'Full price charged at checkout', '2025-08-31 11:30:00', 'low', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (44, 22, 23, 3, 'The discount did not apply', '2025-07-18 13:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (45, 32, 35, 2, 'Incorrect pricing at checkout', '2026-02-01 10:00:00', 'high', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (46, 34, 29, 3, 'Incorrect pricing at checkout', '2025-10-28 08:30:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (47, 31, 39, 2, 'The discount did not apply', '2025-10-21 14:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (48, 39, 24, 3, 'Full price charged at checkout', '2025-09-09 09:30:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (49, 7, 4, 2, 'Incorrect pricing at checkout', '2025-07-12 11:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (50, 37, 33, 3, 'The discount did not apply', '2026-04-06 13:00:00', 'low', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (51, 29, 30, 2, 'Full price charged at checkout', '2025-12-05 08:00:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (52, 32, 36, 3, 'Full price charged at checkout', '2026-03-30 10:30:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (53, 27, 12, 2, 'The discount did not apply', '2025-09-26 14:00:00', 'medium', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (54, 33, 26, 3, 'The discount did not apply', '2025-08-21 09:00:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (55, 36, 26, 2, 'The discount did not apply', '2025-10-18 11:30:00', 'medium', 'Discount removed successfully');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (56, 34, 21, 3, 'The discount did not apply', '2025-04-20 13:00:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (57, 24, 31, 2, 'Full price charged at checkout', '2025-08-17 10:00:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (58, 14, 39, 3, 'Full price charged at checkout', '2025-08-11 08:30:00', 'medium', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (59, 5, 27, 2, 'Incorrect pricing at checkout', '2025-11-08 14:00:00', 'low', 'Invalid promotion code');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (60, 4, 36, 3, 'Incorrect pricing at checkout', '2025-04-29 09:30:00', 'low', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (61, 2, 16, 3, 'Full price charged at checkout', '2025-11-29 10:00:00', 'high', 'Promotion not applicable');
insert into Report (Report_Id, Student_Id, Discount_Id, Admin_Id, Report_Msg, Submitted_At, Priority, Resolution) values (62, 1, 5, 2, 'Discount code was not accepted', '2026-01-09 11:30:00', 'medium', 'Invalid promotion code');


-- Notification
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (4, 40, 'New Discount', 'A new buy one get one free offer just dropped', '2025-11-02 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (5, 37, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2026-03-28 08:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (6, 28, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-06-24 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (7, 36, 'New Discount', 'A new 50% off deal is available near you', '2026-01-10 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (8, 25, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-05-13 09:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (9, 38, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2025-10-20 11:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (10, 30, 'New Discount', 'A new 50% off deal is available near you', '2025-11-29 13:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (11, 31, 'New Discount', 'A new 50% off deal is available near you', '2025-09-04 08:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (12, 33, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-06-20 10:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (13, 20, 'New Discount', 'A new 50% off deal is available near you', '2025-11-04 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (14, 35, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2026-01-04 09:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (15, 3, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2026-03-23 11:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (16, 15, 'New Discount', 'A new deal alert is live at a business near you', '2026-01-02 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (17, 16, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2026-02-23 08:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (18, 3, 'New Discount', 'A new deal alert is live at a business near you', '2026-01-01 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (19, 36, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2025-05-20 14:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (20, 4, 'Report Resolved', 'Your report on a limited time offer has been resolved', '2025-12-22 09:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (21, 34, 'Report Resolved', 'Your report on a limited time offer has been resolved', '2025-12-30 11:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (22, 28, 'New Discount', 'A new buy one get one free offer just dropped', '2025-07-26 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (23, 31, 'New Discount', 'A new buy one get one free offer just dropped', '2026-03-31 08:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (24, 32, 'New Discount', 'A new buy one get one free offer just dropped', '2026-01-24 10:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (25, 37, 'New Discount', 'A new 50% off deal is available near you', '2025-10-11 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (26, 27, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-12-30 09:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (27, 33, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-07-25 11:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (28, 24, 'Report Resolved', 'Your report on a limited time offer has been resolved', '2025-09-30 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (29, 24, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2025-08-11 08:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (30, 23, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2025-05-21 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (31, 22, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2025-08-30 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (32, 31, 'New Discount', 'A new buy one get one free offer just dropped', '2026-03-22 09:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (33, 23, 'New Discount', 'A new 50% off deal is available near you', '2026-01-26 11:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (34, 36, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2025-06-30 13:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (35, 36, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-08-14 08:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (36, 32, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2025-11-29 10:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (37, 8, 'New Discount', 'A new buy one get one free offer just dropped', '2025-12-26 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (38, 22, 'Report Resolved', 'Your report on a limited time offer has been resolved', '2025-06-04 09:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (39, 33, 'New Discount', 'A new buy one get one free offer just dropped', '2026-03-13 11:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (40, 36, 'New Discount', 'A limited time offer is now available near you', '2025-04-16 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (41, 40, 'New Discount', 'A new buy one get one free offer just dropped', '2025-07-08 08:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (42, 28, 'New Discount', 'A new buy one get one free offer just dropped', '2025-07-07 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (43, 4, 'New Discount', 'A new deal alert is live at a business near you', '2025-08-21 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (44, 26, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2025-08-06 09:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (45, 21, 'New Discount', 'A new 50% off deal is available near you', '2026-03-10 11:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (46, 24, 'New Discount', 'A new 50% off deal is available near you', '2025-07-22 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (47, 24, 'New Discount', 'A new buy one get one free offer just dropped', '2025-04-10 08:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (48, 20, 'New Discount', 'A new buy one get one free offer just dropped', '2025-08-11 10:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (49, 39, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-04-10 14:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (50, 29, 'New Discount', 'A new buy one get one free offer just dropped', '2025-07-27 09:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (51, 37, 'New Discount', 'A new 50% off deal is available near you', '2026-01-22 11:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (52, 37, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2025-11-12 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (53, 32, 'New Discount', 'A limited time offer is now available near you', '2025-10-30 08:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (54, 35, 'New Discount', 'A new buy one get one free offer just dropped', '2025-07-18 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (55, 28, 'New Discount', 'A new buy one get one free offer just dropped', '2025-11-21 14:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (56, 36, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2025-08-02 09:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (57, 39, 'Report Resolved', 'Your report on a limited time offer has been resolved', '2025-08-20 11:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (58, 40, 'Report Resolved', 'Your deal alert report has been reviewed and resolved', '2026-01-10 13:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (59, 37, 'Report Resolved', 'Your report on a limited time offer has been resolved', '2025-06-04 08:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (60, 9, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2025-11-02 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (61, 2, 'Report Resolved', 'Your report on the buy one get one free deal has been resolved', '2025-08-25 10:00:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (62, 21, 'Report Resolved', 'Your report on the 50% off promotion has been resolved', '2025-10-22 11:30:00');
insert into Notification (Notif_Id, Student_Id, Notif_Type, Notif_Msg, Sent_Date) values (63, 14, 'New Discount', 'A new 50% off deal is available near you', '2025-11-09 09:00:00');

-- Listing_Analytics
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (3, 14, 21, 42, 97);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (4, 40, 85, 59, 58);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (5, 39, 66, 89, 70);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (6, 29, 64, 44, 4);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (7, 32, 16, 1, 24);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (8, 36, 32, 19, 39);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (9, 38, 74, 30, 89);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (10, 20, 79, 48, 16);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (11, 4, 23, 83, 58);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (12, 27, 83, 95, 20);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (13, 10, 34, 24, 59);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (14, 1, 70, 51, 7);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (15, 14, 77, 97, 62);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (16, 28, 8, 65, 52);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (17, 33, 49, 17, 88);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (18, 19, 33, 41, 76);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (19, 38, 52, 40, 6);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (20, 20, 17, 47, 42);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (21, 32, 97, 67, 70);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (22, 39, 79, 41, 8);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (23, 37, 60, 95, 18);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (24, 22, 57, 83, 63);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (25, 13, 23, 74, 70);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (26, 23, 61, 22, 94);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (27, 3, 12, 34, 61);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (28, 36, 46, 47, 94);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (29, 9, 51, 98, 44);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (30, 16, 44, 26, 86);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (31, 32, 96, 34, 29);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (32, 13, 79, 43, 67);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (33, 26, 55, 43, 3);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (34, 39, 21, 60, 28);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (35, 38, 65, 68, 63);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (36, 31, 22, 34, 41);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (37, 18, 58, 47, 72);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (38, 11, 67, 26, 48);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (39, 7, 28, 79, 29);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (40, 8, 37, 96, 36);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (41, 12, 91, 59, 45);
insert into Listing_Analytics (Analytics_Id, Disc_Id, View_Count, Save_Count, Redemption_Count) values (42, 35, 50, 55, 20);

-- Traffic_Snapshot Data
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (3, 1, '2025-09-15 00:00:00', '2025-09-21 23:59:59', 'Week 3 September', 256);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (4, 1, '2025-09-22 00:00:00', '2025-09-28 23:59:59', 'Week 4 September', 310);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (5, 1, '2025-10-01 00:00:00', '2025-10-07 23:59:59', 'Week 1 October', 175);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (6, 1, '2025-10-08 00:00:00', '2025-10-14 23:59:59', 'Week 2 October', 289);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (7, 1, '2025-10-15 00:00:00', '2025-10-21 23:59:59', 'Week 3 October', 412);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (8, 1, '2025-10-22 00:00:00', '2025-10-28 23:59:59', 'Week 4 October', 267);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (9, 1, '2025-11-01 00:00:00', '2025-11-07 23:59:59', 'Week 1 November', 335);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (10, 1, '2025-11-08 00:00:00', '2025-11-14 23:59:59', 'Week 2 November', 158);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (11, 1, '2025-11-15 00:00:00', '2025-11-21 23:59:59', 'Week 3 November', 401);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (12, 1, '2025-11-22 00:00:00', '2025-11-28 23:59:59', 'Week 4 November', 478);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (13, 1, '2025-12-01 00:00:00', '2025-12-07 23:59:59', 'Week 1 December', 523);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (14, 1, '2025-12-08 00:00:00', '2025-12-14 23:59:59', 'Week 2 December', 387);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (15, 1, '2025-12-15 00:00:00', '2025-12-21 23:59:59', 'Week 3 December', 291);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (16, 1, '2025-12-22 00:00:00', '2025-12-28 23:59:59', 'Week 4 December', 164);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (17, 1, '2026-01-01 00:00:00', '2026-01-07 23:59:59', 'Week 1 January', 203);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (18, 1, '2026-01-08 00:00:00', '2026-01-14 23:59:59', 'Week 2 January', 346);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (19, 2, '2025-09-01 00:00:00', '2025-09-07 23:59:59', 'Week 1 September', 89);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (20, 2, '2025-09-08 00:00:00', '2025-09-14 23:59:59', 'Week 2 September', 112);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (21, 2, '2025-09-15 00:00:00', '2025-09-21 23:59:59', 'Week 3 September', 134);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (22, 2, '2025-09-22 00:00:00', '2025-09-28 23:59:59', 'Week 4 September', 97);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (23, 2, '2025-10-01 00:00:00', '2025-10-07 23:59:59', 'Week 1 October', 203);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (24, 2, '2025-10-08 00:00:00', '2025-10-14 23:59:59', 'Week 2 October', 178);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (25, 2, '2025-10-15 00:00:00', '2025-10-21 23:59:59', 'Week 3 October', 245);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (26, 2, '2025-10-22 00:00:00', '2025-10-28 23:59:59', 'Week 4 October', 156);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (27, 2, '2025-11-01 00:00:00', '2025-11-07 23:59:59', 'Week 1 November', 189);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (28, 2, '2025-11-08 00:00:00', '2025-11-14 23:59:59', 'Week 2 November', 221);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (29, 2, '2025-11-15 00:00:00', '2025-11-21 23:59:59', 'Week 3 November', 267);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (30, 2, '2025-11-22 00:00:00', '2025-11-28 23:59:59', 'Week 4 November', 312);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (31, 2, '2025-12-01 00:00:00', '2025-12-07 23:59:59', 'Week 1 December', 345);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (32, 2, '2025-12-08 00:00:00', '2025-12-14 23:59:59', 'Week 2 December', 278);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (33, 2, '2025-12-15 00:00:00', '2025-12-21 23:59:59', 'Week 3 December', 198);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (34, 2, '2025-12-22 00:00:00', '2025-12-28 23:59:59', 'Week 4 December', 143);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (35, 2, '2026-01-01 00:00:00', '2026-01-07 23:59:59', 'Week 1 January', 176);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (36, 2, '2026-01-08 00:00:00', '2026-01-14 23:59:59', 'Week 2 January', 234);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (37, 3, '2026-01-20 00:00:00', '2026-01-26 23:59:59', 'Week 3 January', 67);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (38, 3, '2026-01-27 00:00:00', '2026-02-02 23:59:59', 'Week 4 January', 45);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (39, 3, '2026-02-03 00:00:00', '2026-02-09 23:59:59', 'Week 1 February', 78);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (40, 3, '2026-02-10 00:00:00', '2026-02-16 23:59:59', 'Week 2 February', 52);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (41, 1, '2026-01-15 00:00:00', '2026-01-21 23:59:59', 'Week 3 January', 129);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (42, 1, '2026-01-22 00:00:00', '2026-01-28 23:59:59', 'Week 4 January', 415);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (43, 1, '2026-02-01 00:00:00', '2026-02-07 23:59:59', 'Week 1 February', 278);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (44, 1, '2026-02-08 00:00:00', '2026-02-14 23:59:59', 'Week 2 February', 502);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (45, 2, '2026-01-15 00:00:00', '2026-01-21 23:59:59', 'Week 3 January', 189);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (46, 2, '2026-01-22 00:00:00', '2026-01-28 23:59:59', 'Week 4 January', 364);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (47, 2, '2026-02-01 00:00:00', '2026-02-07 23:59:59', 'Week 1 February', 441);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (48, 2, '2026-02-08 00:00:00', '2026-02-14 23:59:59', 'Week 2 February', 312);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (49, 3, '2026-02-17 00:00:00', '2026-02-23 23:59:59', 'Week 3 February', 91);
insert into Traffic_Snapshot (Snapshot_Id, Biz_Id, Period_Start, Period_End, Period_Label, Traffic_Count) values (50, 3, '2026-02-24 00:00:00', '2026-03-02 23:59:59', 'Week 4 February', 38);


-- Competitor_Listing Data
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (3, 1, 'Pizza Hut Fenway', 18, 25, 210);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (4, 1, 'Blaze Pizza Back Bay', 12, 42, 330);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (5, 1, 'Otto Pizza Cambridge', 10, 37, 285);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (6, 1, 'Oath Pizza Allston', 22, 14, 120);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (7, 1, 'Regina Pizzeria North End', 8, 56, 440);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (8, 1, 'Santarpios East Boston', 15, 21, 175);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (9, 1, 'Locale Pizzeria Southie', 25, 9, 88);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (10, 1, 'Area Four Kendall', 17, 31, 248);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (11, 1, 'Lil Donkey Central', 20, 16, 138);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (12, 1, 'Upper Crust Beacon Hill', 13, 28, 225);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (13, 1, 'Flatbread Company Davis', 30, 8, 72);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (14, 1, 'Hot Tomatoes Brighton', 11, 44, 350);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (15, 1, 'Ernos North End', 19, 13, 110);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (16, 1, 'Same Old Place Jamaica Plain', 14, 35, 280);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (17, 2, 'Harvard Book Store', 10, 45, 320);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (18, 2, 'MIT Press Bookstore', 12, 22, 180);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (19, 2, 'Barnes Noble BU', 8, 37, 295);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (20, 2, 'Brookline Booksmith', 15, 19, 155);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (21, 2, 'Trident Booksellers Newbury', 18, 14, 128);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (22, 2, 'Porter Square Books', 20, 11, 98);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (23, 2, 'Newtonville Books', 7, 52, 410);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (24, 2, 'Belmont Books', 9, 29, 235);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (25, 2, 'Books Bop Somerville', 25, 6, 55);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (26, 2, 'Commonwealth Books Downtown', 11, 33, 268);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (27, 2, 'Papercuts JP', 16, 17, 142);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (28, 2, 'More Than Words Waltham', 13, 24, 195);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (29, 2, 'Raven Used Books Harvard', 22, 8, 70);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (30, 2, 'Schoenhofs Foreign Books', 5, 61, 485);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (31, 2, 'Rodney Bookstore BU', 14, 20, 165);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (32, 2, 'Brattle Book Shop', 17, 15, 125);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (33, 2, 'Beacon Hill Books', 10, 38, 305);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (34, 3, 'Best Buy Student', 8, 67, 510);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (35, 3, 'Micro Center Cambridge', 12, 34, 290);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (36, 3, 'Amazon Student Prime', 15, 82, 640);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (37, 3, 'Newegg Campus', 10, 41, 325);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (38, 3, 'B and H Photo EDU', 18, 23, 190);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (39, 3, 'Apple Education Store', 7, 75, 580);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (40, 3, 'Dell University', 20, 15, 130);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (41, 3, 'Lenovo Student', 22, 12, 105);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (42, 3, 'HP Academy', 14, 28, 228);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (43, 3, 'Samsung Student Store', 25, 9, 78);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (44, 3, 'Staples Tech BU', 11, 36, 290);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (45, 3, 'CDW Campus', 16, 18, 150);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (46, 3, 'Adorama Student', 13, 22, 180);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (47, 3, 'Monoprice EDU', 30, 5, 45);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (48, 3, 'Costco Tech Cambridge', 9, 48, 380);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (49, 3, 'Target Tech Fenway', 6, 55, 430);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (50, 3, 'Walmart Electronics Quincy', 8, 43, 345);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (51, 1, 'Dominos NEU', 15, 30, 200);
insert into Competitor_Listing (Competitor_Id, Biz_Id, Biz_Name, Disc_Amount, Redemption_Count, View_Count) values (52, 1, 'Papa Ginos Boston', 20, 18, 145);

-- Platform_Metrics Data
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (3, 1, 1050, 40, 7, '2025-11-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (4, 1, 1180, 44, 2, '2025-12-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (5, 1, 1250, 47, 3, '2026-01-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (6, 1, 1280, 52, 1, '2026-01-22 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (7, 1, 1310, 50, 4, '2026-02-01 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (8, 1, 1345, 48, 6, '2026-02-08 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (9, 1, 1380, 53, 2, '2026-02-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (10, 1, 1420, 55, 5, '2026-02-22 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (11, 1, 1460, 57, 3, '2026-03-01 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (12, 1, 1490, 54, 8, '2026-03-08 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (13, 1, 1525, 59, 1, '2026-03-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (14, 1, 1560, 61, 4, '2026-03-22 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (15, 1, 1590, 58, 7, '2026-03-29 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (16, 1, 1620, 62, 2, '2026-04-05 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (17, 2, 780, 28, 4, '2025-09-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (18, 2, 840, 31, 6, '2025-10-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (19, 2, 950, 36, 1, '2025-11-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (20, 2, 1020, 39, 8, '2025-12-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (21, 2, 1080, 42, 3, '2026-01-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (22, 2, 1120, 44, 5, '2026-01-22 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (23, 2, 1155, 41, 2, '2026-02-01 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (24, 2, 1190, 46, 7, '2026-02-08 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (25, 2, 1230, 48, 1, '2026-02-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (26, 2, 1260, 45, 9, '2026-02-22 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (27, 2, 1290, 50, 3, '2026-03-01 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (28, 2, 1320, 52, 6, '2026-03-08 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (29, 2, 1350, 49, 2, '2026-03-15 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (30, 2, 1380, 54, 4, '2026-03-22 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (31, 2, 1410, 51, 8, '2026-03-29 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (32, 2, 1440, 56, 1, '2026-04-05 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (33, 3, 120, 5, 2, '2026-01-20 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (34, 3, 145, 7, 4, '2026-01-27 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (35, 3, 160, 6, 1, '2026-02-03 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (36, 3, 178, 8, 6, '2026-02-10 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (37, 3, 195, 9, 3, '2026-02-17 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (38, 3, 210, 7, 5, '2026-02-24 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (39, 3, 230, 10, 2, '2026-03-03 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (40, 3, 245, 11, 7, '2026-03-10 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (41, 3, 260, 9, 1, '2026-03-17 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (42, 3, 275, 12, 4, '2026-03-24 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (43, 3, 290, 10, 8, '2026-03-31 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (44, 3, 305, 13, 2, '2026-04-07 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (45, 1, 1650, 60, 9, '2026-04-07 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (46, 2, 1470, 55, 3, '2026-04-07 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (47, 1, 1680, 63, 5, '2026-04-12 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (48, 2, 1500, 57, 6, '2026-04-12 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (49, 3, 320, 14, 3, '2026-04-12 00:00:00');
insert into Platform_Metrics (Metrics_Id, Biz_Id, Total_Users, Active_Discs, Pending_Rpts, Snapshot_Date) values (50, 3, 335, 15, 1, '2026-04-13 00:00:00');
