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


-- University Data
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

-- Business Data
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (1, 'Oyoba', 'https://walmart.com/elit/ac/nulla.json?varius=pellentesque&nulla=volutpat&facilisi=dui&cras=maecenas&non=tristique&velit=est&nec=et&nisi=tempus&vulputate=semper&nonummy=est&maecenas=quam&tincidunt=pharetra&lacus=magna&at=ac&velit=consequat&vivamus=metus&vel=sapien&nulla=ut&eget=nunc&eros=vestibulum&elementum=ante&pellentesque=ipsum&quisque=primis&porta=in&volutpat=faucibus&erat=orci&quisque=luctus&erat=et&eros=ultrices&viverra=posuere&eget=cubilia&congue=curae&eget=mauris&semper=viverra&rutrum=diam&nulla=vitae&nunc=quam&purus=suspendisse&phasellus=potenti&in=nullam&felis=porttitor&donec=lacus&semper=at&sapien=turpis&a=donec&libero=posuere', 'Room 697', 'Bellanca', 'bcowles0@howstuffworks.com', '878-244-9715');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (2, 'Camido', 'https://scientificamerican.com/semper/sapien/a/libero.png?at=eget&velit=congue&vivamus=eget&vel=semper&nulla=rutrum&eget=nulla&eros=nunc&elementum=purus&pellentesque=phasellus&quisque=in&porta=felis&volutpat=donec&erat=semper&quisque=sapien&erat=a&eros=libero&viverra=nam&eget=dui&congue=proin&eget=leo&semper=odio&rutrum=porttitor&nulla=id&nunc=consequat&purus=in&phasellus=consequat&in=ut&felis=nulla&donec=sed&semper=accumsan&sapien=felis&a=ut&libero=at&nam=dolor&dui=quis&proin=odio&leo=consequat&odio=varius&porttitor=integer&id=ac&consequat=leo&in=pellentesque&consequat=ultrices&ut=mattis&nulla=odio&sed=donec&accumsan=vitae&felis=nisi&ut=nam', 'Apt 1831', 'Ware', 'wdeferrari1@vinaora.com', '400-811-1008');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (3, 'Yodoo', 'http://usda.gov/purus/sit/amet.json?vel=ante&lectus=vel&in=ipsum&quam=praesent&fringilla=blandit&rhoncus=lacinia&mauris=erat&enim=vestibulum&leo=sed&rhoncus=magna&sed=at&vestibulum=nunc&sit=commodo&amet=placerat&cursus=praesent&id=blandit&turpis=nam&integer=nulla&aliquet=integer&massa=pede&id=justo&lobortis=lacinia&convallis=eget&tortor=tincidunt&risus=eget&dapibus=tempus&augue=vel&vel=pede&accumsan=morbi&tellus=porttitor&nisi=lorem&eu=id&orci=ligula&mauris=suspendisse&lacinia=ornare&sapien=consequat&quis=lectus&libero=in&nullam=est&sit=risus&amet=auctor&turpis=sed&elementum=tristique&ligula=in&vehicula=tempus&consequat=sit&morbi=amet&a=sem&ipsum=fusce&integer=consequat&a=nulla&nibh=nisl&in=nunc&quis=nisl&justo=duis&maecenas=bibendum&rhoncus=felis&aliquam=sed&lacus=interdum&morbi=venenatis&quis=turpis&tortor=enim&id=blandit&nulla=mi&ultrices=in&aliquet=porttitor&maecenas=pede&leo=justo&odio=eu&condimentum=massa&id=donec&luctus=dapibus&nec=duis&molestie=at&sed=velit&justo=eu&pellentesque=est&viverra=congue&pede=elementum&ac=in&diam=hac&cras=habitasse&pellentesque=platea&volutpat=dictumst&dui=morbi&maecenas=vestibulum&tristique=velit&est=id&et=pretium&tempus=iaculis&semper=diam&est=erat&quam=fermentum&pharetra=justo&magna=nec&ac=condimentum&consequat=neque&metus=sapien&sapien=placerat&ut=ante', '19th Floor', 'Jenn', 'jsmewings2@mozilla.com', '170-263-5274');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (4, 'Trilith', 'http://sciencedaily.com/nullam.html?eu=ultrices&sapien=phasellus&cursus=id&vestibulum=sapien&proin=in&eu=sapien&mi=iaculis&nulla=congue&ac=vivamus&enim=metus&in=arcu&tempor=adipiscing&turpis=molestie&nec=hendrerit&euismod=at&scelerisque=vulputate&quam=vitae&turpis=nisl&adipiscing=aenean&lorem=lectus&vitae=pellentesque&mattis=eget&nibh=nunc&ligula=donec&nec=quis&sem=orci&duis=eget&aliquam=orci&convallis=vehicula&nunc=condimentum&proin=curabitur&at=in', 'PO Box 40739', 'Amandi', 'awhannel3@fastcompany.com', '440-423-4317');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (5, 'Wikibox', 'http://europa.eu/amet/nulla/quisque/arcu/libero/rutrum.xml?pulvinar=sollicitudin&sed=ut&nisl=suscipit&nunc=a&rhoncus=feugiat&dui=et&vel=eros&sem=vestibulum&sed=ac&sagittis=est&nam=lacinia&congue=nisi&risus=venenatis&semper=tristique&porta=fusce&volutpat=congue&quam=diam&pede=id&lobortis=ornare&ligula=imperdiet&sit=sapien&amet=urna&eleifend=pretium&pede=nisl&libero=ut&quis=volutpat&orci=sapien&nullam=arcu&molestie=sed&nibh=augue&in=aliquam&lectus=erat&pellentesque=volutpat&at=in&nulla=congue&suspendisse=etiam&potenti=justo&cras=etiam&in=pretium&purus=iaculis&eu=justo&magna=in&vulputate=hac&luctus=habitasse&cum=platea&sociis=dictumst&natoque=etiam&penatibus=faucibus&et=cursus&magnis=urna&dis=ut&parturient=tellus&montes=nulla&nascetur=ut&ridiculus=erat&mus=id&vivamus=mauris&vestibulum=vulputate&sagittis=elementum&sapien=nullam&cum=varius&sociis=nulla&natoque=facilisi&penatibus=cras&et=non&magnis=velit&dis=nec&parturient=nisi&montes=vulputate&nascetur=nonummy&ridiculus=maecenas&mus=tincidunt&etiam=lacus&vel=at&augue=velit&vestibulum=vivamus&rutrum=vel&rutrum=nulla&neque=eget&aenean=eros&auctor=elementum&gravida=pellentesque&sem=quisque&praesent=porta&id=volutpat&massa=erat', '3rd Floor', 'Tabor', 'telleton4@springer.com', '314-840-2285');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (6, 'Photojam', 'http://cnbc.com/libero/ut/massa/volutpat/convallis.js?sed=nunc&vestibulum=donec&sit=quis&amet=orci&cursus=eget&id=orci&turpis=vehicula&integer=condimentum&aliquet=curabitur&massa=in&id=libero&lobortis=ut&convallis=massa&tortor=volutpat&risus=convallis&dapibus=morbi&augue=odio&vel=odio&accumsan=elementum&tellus=eu&nisi=interdum&eu=eu&orci=tincidunt&mauris=in&lacinia=leo&sapien=maecenas&quis=pulvinar&libero=lobortis&nullam=est&sit=phasellus&amet=sit&turpis=amet&elementum=erat&ligula=nulla&vehicula=tempus&consequat=vivamus&morbi=in&a=felis&ipsum=eu&integer=sapien&a=cursus&nibh=vestibulum&in=proin&quis=eu&justo=mi&maecenas=nulla&rhoncus=ac&aliquam=enim&lacus=in&morbi=tempor&quis=turpis&tortor=nec&id=euismod&nulla=scelerisque&ultrices=quam&aliquet=turpis&maecenas=adipiscing&leo=lorem&odio=vitae&condimentum=mattis&id=nibh&luctus=ligula&nec=nec&molestie=sem&sed=duis&justo=aliquam&pellentesque=convallis&viverra=nunc&pede=proin&ac=at&diam=turpis&cras=a&pellentesque=pede&volutpat=posuere&dui=nonummy&maecenas=integer&tristique=non&est=velit&et=donec&tempus=diam&semper=neque', 'PO Box 31240', 'Denney', 'dwillshire5@ted.com', '909-854-5382');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (7, 'Quatz', 'https://independent.co.uk/vel/nisl/duis/ac/nibh/fusce/lacus.xml?suscipit=mi&nulla=in&elit=porttitor&ac=pede&nulla=justo&sed=eu&vel=massa&enim=donec&sit=dapibus&amet=duis&nunc=at', 'Apt 688', 'Thalia', 'tragg6@engadget.com', '373-389-9967');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (8, 'Ailane', 'https://cafepress.com/amet/erat/nulla/tempus/vivamus/in/felis.json?nulla=erat&integer=nulla&pede=tempus&justo=vivamus&lacinia=in&eget=felis&tincidunt=eu&eget=sapien&tempus=cursus&vel=vestibulum&pede=proin&morbi=eu&porttitor=mi&lorem=nulla&id=ac&ligula=enim&suspendisse=in&ornare=tempor&consequat=turpis&lectus=nec&in=euismod&est=scelerisque&risus=quam&auctor=turpis&sed=adipiscing&tristique=lorem&in=vitae&tempus=mattis&sit=nibh&amet=ligula&sem=nec&fusce=sem', 'Suite 59', 'Dulcea', 'dhadkins7@artisteer.com', '141-448-8786');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (9, 'Mybuzz', 'https://deviantart.com/curae/donec/pharetra/magna/vestibulum/aliquet/ultrices.xml?sit=commodo&amet=vulputate&lobortis=justo&sapien=in&sapien=blandit&non=ultrices&mi=enim&integer=lorem&ac=ipsum&neque=dolor&duis=sit&bibendum=amet&morbi=consectetuer&non=adipiscing&quam=elit&nec=proin&dui=interdum&luctus=mauris&rutrum=non', 'Suite 91', 'Lorelei', 'lmcmillian8@admin.ch', '546-484-7724');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (10, 'Divape', 'https://elegantthemes.com/erat/volutpat.aspx?in=pellentesque&ante=at&vestibulum=nulla&ante=suspendisse&ipsum=potenti&primis=cras&in=in&faucibus=purus&orci=eu&luctus=magna&et=vulputate&ultrices=luctus&posuere=cum&cubilia=sociis&curae=natoque&duis=penatibus&faucibus=et&accumsan=magnis&odio=dis&curabitur=parturient&convallis=montes&duis=nascetur&consequat=ridiculus&dui=mus&nec=vivamus&nisi=vestibulum&volutpat=sagittis&eleifend=sapien&donec=cum&ut=sociis&dolor=natoque&morbi=penatibus&vel=et&lectus=magnis&in=dis&quam=parturient&fringilla=montes&rhoncus=nascetur&mauris=ridiculus&enim=mus&leo=etiam&rhoncus=vel&sed=augue&vestibulum=vestibulum&sit=rutrum&amet=rutrum&cursus=neque&id=aenean&turpis=auctor&integer=gravida&aliquet=sem&massa=praesent&id=id&lobortis=massa&convallis=id&tortor=nisl&risus=venenatis&dapibus=lacinia&augue=aenean&vel=sit&accumsan=amet', 'Suite 4', 'Felipe', 'fyoungman9@google.ca', '313-829-7661');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (11, 'Gabspot', 'http://pen.io/sed/justo/pellentesque.aspx?varius=pellentesque&ut=quisque&blandit=porta&non=volutpat&interdum=erat&in=quisque', 'Suite 59', 'Thurston', 'tphoenixa@china.com.cn', '964-469-5653');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (12, 'Wikido', 'https://barnesandnoble.com/mattis/nibh/ligula/nec/sem/duis.png?ante=porttitor&ipsum=lacus&primis=at&in=turpis&faucibus=donec&orci=posuere&luctus=metus&et=vitae&ultrices=ipsum&posuere=aliquam&cubilia=non&curae=mauris&donec=morbi&pharetra=non&magna=lectus&vestibulum=aliquam&aliquet=sit&ultrices=amet&erat=diam&tortor=in&sollicitudin=magna&mi=bibendum&sit=imperdiet&amet=nullam&lobortis=orci&sapien=pede&sapien=venenatis&non=non&mi=sodales&integer=sed&ac=tincidunt&neque=eu&duis=felis&bibendum=fusce&morbi=posuere&non=felis&quam=sed&nec=lacus&dui=morbi&luctus=sem&rutrum=mauris&nulla=laoreet&tellus=ut&in=rhoncus&sagittis=aliquet&dui=pulvinar&vel=sed&nisl=nisl&duis=nunc&ac=rhoncus&nibh=dui&fusce=vel&lacus=sem&purus=sed&aliquet=sagittis&at=nam&feugiat=congue&non=risus&pretium=semper&quis=porta&lectus=volutpat&suspendisse=quam&potenti=pede&in=lobortis&eleifend=ligula&quam=sit&a=amet&odio=eleifend&in=pede&hac=libero&habitasse=quis&platea=orci&dictumst=nullam&maecenas=molestie&ut=nibh&massa=in&quis=lectus&augue=pellentesque&luctus=at&tincidunt=nulla&nulla=suspendisse&mollis=potenti&molestie=cras&lorem=in&quisque=purus&ut=eu&erat=magna&curabitur=vulputate&gravida=luctus&nisi=cum', 'Suite 54', 'Wynn', 'wvasyukhnovb@omniture.com', '726-908-2992');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (13, 'Divavu', 'https://samsung.com/nibh.xml?nullam=orci&sit=nullam&amet=molestie&turpis=nibh&elementum=in&ligula=lectus&vehicula=pellentesque&consequat=at', '20th Floor', 'Geordie', 'gcorranc@sina.com.cn', '776-287-6896');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (14, 'Photojam', 'http://github.io/sapien/cursus/vestibulum.js?tellus=nullam&in=orci&sagittis=pede&dui=venenatis&vel=non&nisl=sodales&duis=sed&ac=tincidunt&nibh=eu&fusce=felis&lacus=fusce&purus=posuere&aliquet=felis&at=sed&feugiat=lacus&non=morbi&pretium=sem&quis=mauris&lectus=laoreet&suspendisse=ut&potenti=rhoncus&in=aliquet&eleifend=pulvinar&quam=sed&a=nisl&odio=nunc&in=rhoncus&hac=dui&habitasse=vel&platea=sem&dictumst=sed&maecenas=sagittis&ut=nam&massa=congue&quis=risus&augue=semper&luctus=porta&tincidunt=volutpat&nulla=quam&mollis=pede&molestie=lobortis&lorem=ligula', '19th Floor', 'Shane', 'slanfeard@berkeley.edu', '820-365-0703');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (15, 'Edgeblab', 'https://feedburner.com/nisi/volutpat/eleifend/donec/ut/dolor.json?parturient=est&montes=risus&nascetur=auctor&ridiculus=sed&mus=tristique&vivamus=in&vestibulum=tempus&sagittis=sit&sapien=amet&cum=sem&sociis=fusce&natoque=consequat&penatibus=nulla&et=nisl&magnis=nunc&dis=nisl&parturient=duis&montes=bibendum&nascetur=felis&ridiculus=sed&mus=interdum&etiam=venenatis&vel=turpis&augue=enim&vestibulum=blandit&rutrum=mi&rutrum=in&neque=porttitor&aenean=pede&auctor=justo&gravida=eu&sem=massa&praesent=donec&id=dapibus&massa=duis&id=at&nisl=velit&venenatis=eu&lacinia=est&aenean=congue&sit=elementum&amet=in&justo=hac&morbi=habitasse&ut=platea&odio=dictumst&cras=morbi&mi=vestibulum&pede=velit&malesuada=id&in=pretium&imperdiet=iaculis&et=diam&commodo=erat&vulputate=fermentum&justo=justo&in=nec&blandit=condimentum&ultrices=neque&enim=sapien&lorem=placerat&ipsum=ante&dolor=nulla&sit=justo&amet=aliquam&consectetuer=quis&adipiscing=turpis&elit=eget&proin=elit&interdum=sodales&mauris=scelerisque&non=mauris&ligula=sit&pellentesque=amet&ultrices=eros&phasellus=suspendisse&id=accumsan&sapien=tortor&in=quis&sapien=turpis&iaculis=sed&congue=ante&vivamus=vivamus&metus=tortor', 'Apt 391', 'Charley', 'clubertie@symantec.com', '305-308-0647');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (16, 'Oyope', 'https://nydailynews.com/duis/ac/nibh.aspx?consequat=interdum&dui=mauris&nec=non&nisi=ligula&volutpat=pellentesque&eleifend=ultrices&donec=phasellus&ut=id&dolor=sapien&morbi=in', 'PO Box 76981', 'Page', 'pgridonf@moonfruit.com', '433-376-6979');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (17, 'Miboo', 'http://cisco.com/sagittis/dui/vel/nisl/duis.jsp?duis=proin&mattis=eu&egestas=mi&metus=nulla&aenean=ac&fermentum=enim&donec=in&ut=tempor&mauris=turpis&eget=nec&massa=euismod&tempor=scelerisque&convallis=quam&nulla=turpis&neque=adipiscing&libero=lorem&convallis=vitae&eget=mattis&eleifend=nibh&luctus=ligula&ultricies=nec&eu=sem&nibh=duis&quisque=aliquam&id=convallis&justo=nunc&sit=proin&amet=at&sapien=turpis&dignissim=a&vestibulum=pede&vestibulum=posuere&ante=nonummy&ipsum=integer&primis=non&in=velit&faucibus=donec&orci=diam&luctus=neque&et=vestibulum&ultrices=eget&posuere=vulputate&cubilia=ut&curae=ultrices&nulla=vel&dapibus=augue&dolor=vestibulum&vel=ante&est=ipsum&donec=primis&odio=in&justo=faucibus&sollicitudin=orci&ut=luctus&suscipit=et&a=ultrices&feugiat=posuere&et=cubilia&eros=curae&vestibulum=donec&ac=pharetra&est=magna&lacinia=vestibulum&nisi=aliquet&venenatis=ultrices&tristique=erat&fusce=tortor&congue=sollicitudin&diam=mi&id=sit&ornare=amet&imperdiet=lobortis&sapien=sapien&urna=sapien&pretium=non&nisl=mi&ut=integer&volutpat=ac&sapien=neque&arcu=duis&sed=bibendum&augue=morbi&aliquam=non&erat=quam&volutpat=nec&in=dui&congue=luctus&etiam=rutrum&justo=nulla&etiam=tellus&pretium=in&iaculis=sagittis&justo=dui&in=vel&hac=nisl&habitasse=duis&platea=ac&dictumst=nibh&etiam=fusce&faucibus=lacus', 'Apt 230', 'Wiatt', 'wfuggleg@vimeo.com', '343-763-8069');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (18, 'Fanoodle', 'https://ted.com/non/interdum/in/ante/vestibulum.aspx?nulla=donec&nisl=quis&nunc=orci&nisl=eget&duis=orci&bibendum=vehicula&felis=condimentum&sed=curabitur&interdum=in&venenatis=libero&turpis=ut&enim=massa&blandit=volutpat&mi=convallis&in=morbi&porttitor=odio&pede=odio&justo=elementum&eu=eu&massa=interdum&donec=eu&dapibus=tincidunt&duis=in&at=leo&velit=maecenas&eu=pulvinar&est=lobortis&congue=est&elementum=phasellus&in=sit&hac=amet&habitasse=erat&platea=nulla&dictumst=tempus&morbi=vivamus&vestibulum=in&velit=felis&id=eu&pretium=sapien&iaculis=cursus&diam=vestibulum&erat=proin&fermentum=eu&justo=mi&nec=nulla&condimentum=ac&neque=enim&sapien=in&placerat=tempor&ante=turpis&nulla=nec&justo=euismod&aliquam=scelerisque&quis=quam&turpis=turpis&eget=adipiscing&elit=lorem&sodales=vitae&scelerisque=mattis&mauris=nibh&sit=ligula&amet=nec&eros=sem&suspendisse=duis&accumsan=aliquam&tortor=convallis&quis=nunc&turpis=proin&sed=at&ante=turpis&vivamus=a&tortor=pede&duis=posuere&mattis=nonummy', 'PO Box 52108', 'Donelle', 'dsheranh@sphinn.com', '721-606-3687');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (19, 'Blogspan', 'https://nifty.com/et/magnis/dis/parturient/montes/nascetur/ridiculus.jpg?non=odio&mauris=cras&morbi=mi&non=pede&lectus=malesuada&aliquam=in&sit=imperdiet&amet=et&diam=commodo&in=vulputate&magna=justo&bibendum=in&imperdiet=blandit&nullam=ultrices&orci=enim&pede=lorem&venenatis=ipsum&non=dolor&sodales=sit&sed=amet&tincidunt=consectetuer&eu=adipiscing&felis=elit&fusce=proin&posuere=interdum&felis=mauris&sed=non&lacus=ligula&morbi=pellentesque&sem=ultrices&mauris=phasellus&laoreet=id&ut=sapien&rhoncus=in&aliquet=sapien&pulvinar=iaculis&sed=congue&nisl=vivamus&nunc=metus&rhoncus=arcu&dui=adipiscing&vel=molestie&sem=hendrerit&sed=at&sagittis=vulputate&nam=vitae&congue=nisl&risus=aenean&semper=lectus&porta=pellentesque&volutpat=eget&quam=nunc&pede=donec&lobortis=quis&ligula=orci&sit=eget&amet=orci&eleifend=vehicula&pede=condimentum&libero=curabitur&quis=in&orci=libero&nullam=ut&molestie=massa&nibh=volutpat&in=convallis&lectus=morbi&pellentesque=odio&at=odio&nulla=elementum&suspendisse=eu&potenti=interdum&cras=eu&in=tincidunt&purus=in&eu=leo&magna=maecenas&vulputate=pulvinar', '4th Floor', 'Cecilia', 'cplewmani@uol.com.br', '748-171-4153');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (20, 'Flashdog', 'https://stanford.edu/curae/mauris/viverra/diam/vitae/quam/suspendisse.json?suscipit=vulputate&a=ut&feugiat=ultrices&et=vel&eros=augue&vestibulum=vestibulum&ac=ante&est=ipsum', '5th Floor', 'Rusty', 'runworthj@washington.edu', '629-223-0578');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (21, 'Tazzy', 'http://ycombinator.com/diam/erat/fermentum/justo/nec/condimentum.html?dui=quam&vel=sapien&sem=varius&sed=ut&sagittis=blandit&nam=non&congue=interdum&risus=in&semper=ante&porta=vestibulum&volutpat=ante&quam=ipsum&pede=primis&lobortis=in&ligula=faucibus&sit=orci&amet=luctus&eleifend=et&pede=ultrices&libero=posuere&quis=cubilia&orci=curae&nullam=duis&molestie=faucibus&nibh=accumsan&in=odio&lectus=curabitur&pellentesque=convallis&at=duis&nulla=consequat&suspendisse=dui&potenti=nec&cras=nisi&in=volutpat&purus=eleifend&eu=donec&magna=ut&vulputate=dolor&luctus=morbi&cum=vel&sociis=lectus&natoque=in&penatibus=quam&et=fringilla&magnis=rhoncus&dis=mauris&parturient=enim&montes=leo&nascetur=rhoncus&ridiculus=sed&mus=vestibulum&vivamus=sit&vestibulum=amet&sagittis=cursus&sapien=id&cum=turpis', 'Apt 333', 'Westbrooke', 'wcicchitellok@ameblo.jp', '158-831-9876');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (22, 'Meembee', 'https://prlog.org/felis/eu/sapien/cursus/vestibulum/proin.json?id=quis&consequat=orci&in=eget&consequat=orci&ut=vehicula&nulla=condimentum&sed=curabitur&accumsan=in&felis=libero&ut=ut&at=massa&dolor=volutpat&quis=convallis&odio=morbi&consequat=odio&varius=odio&integer=elementum&ac=eu&leo=interdum&pellentesque=eu&ultrices=tincidunt&mattis=in&odio=leo&donec=maecenas&vitae=pulvinar&nisi=lobortis&nam=est&ultrices=phasellus&libero=sit&non=amet&mattis=erat&pulvinar=nulla&nulla=tempus&pede=vivamus&ullamcorper=in&augue=felis&a=eu&suscipit=sapien&nulla=cursus&elit=vestibulum&ac=proin&nulla=eu&sed=mi&vel=nulla&enim=ac&sit=enim&amet=in&nunc=tempor&viverra=turpis&dapibus=nec&nulla=euismod&suscipit=scelerisque&ligula=quam&in=turpis&lacus=adipiscing&curabitur=lorem&at=vitae&ipsum=mattis&ac=nibh&tellus=ligula&semper=nec&interdum=sem&mauris=duis&ullamcorper=aliquam&purus=convallis', 'Apt 900', 'Ashla', 'adigweedl@phpbb.com', '538-840-7104');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (23, 'Tekfly', 'http://zimbio.com/ultricies/eu/nibh/quisque/id/justo/sit.xml?praesent=nunc&blandit=purus&lacinia=phasellus&erat=in&vestibulum=felis&sed=donec&magna=semper&at=sapien&nunc=a&commodo=libero&placerat=nam&praesent=dui&blandit=proin&nam=leo&nulla=odio&integer=porttitor&pede=id&justo=consequat&lacinia=in&eget=consequat&tincidunt=ut&eget=nulla&tempus=sed&vel=accumsan&pede=felis&morbi=ut&porttitor=at&lorem=dolor&id=quis&ligula=odio&suspendisse=consequat&ornare=varius&consequat=integer&lectus=ac&in=leo&est=pellentesque&risus=ultrices&auctor=mattis&sed=odio&tristique=donec&in=vitae&tempus=nisi&sit=nam&amet=ultrices&sem=libero&fusce=non&consequat=mattis&nulla=pulvinar&nisl=nulla&nunc=pede&nisl=ullamcorper&duis=augue&bibendum=a&felis=suscipit&sed=nulla&interdum=elit&venenatis=ac&turpis=nulla&enim=sed&blandit=vel&mi=enim&in=sit', 'Apt 1496', 'Kip', 'ksendleym@google.de', '133-304-4274');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (24, 'Oloo', 'http://epa.gov/commodo/vulputate/justo/in/blandit/ultrices.xml?nunc=aliquam&vestibulum=non&ante=mauris&ipsum=morbi&primis=non&in=lectus&faucibus=aliquam&orci=sit&luctus=amet&et=diam&ultrices=in&posuere=magna&cubilia=bibendum&curae=imperdiet&mauris=nullam&viverra=orci&diam=pede&vitae=venenatis&quam=non&suspendisse=sodales&potenti=sed&nullam=tincidunt&porttitor=eu&lacus=felis&at=fusce&turpis=posuere&donec=felis&posuere=sed&metus=lacus&vitae=morbi&ipsum=sem&aliquam=mauris&non=laoreet&mauris=ut&morbi=rhoncus&non=aliquet&lectus=pulvinar&aliquam=sed&sit=nisl&amet=nunc&diam=rhoncus&in=dui&magna=vel&bibendum=sem&imperdiet=sed&nullam=sagittis&orci=nam&pede=congue&venenatis=risus&non=semper&sodales=porta&sed=volutpat&tincidunt=quam&eu=pede&felis=lobortis&fusce=ligula&posuere=sit&felis=amet&sed=eleifend&lacus=pede&morbi=libero&sem=quis&mauris=orci&laoreet=nullam&ut=molestie&rhoncus=nibh&aliquet=in&pulvinar=lectus', 'Room 23', 'Tim', 'twhorfn@usa.gov', '693-108-7829');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (25, 'Twitternation', 'https://spiegel.de/nec/sem.jpg?felis=turpis&ut=elementum&at=ligula&dolor=vehicula&quis=consequat&odio=morbi&consequat=a&varius=ipsum&integer=integer&ac=a&leo=nibh&pellentesque=in&ultrices=quis&mattis=justo&odio=maecenas&donec=rhoncus&vitae=aliquam&nisi=lacus&nam=morbi&ultrices=quis&libero=tortor&non=id&mattis=nulla&pulvinar=ultrices&nulla=aliquet&pede=maecenas&ullamcorper=leo&augue=odio&a=condimentum&suscipit=id&nulla=luctus&elit=nec&ac=molestie&nulla=sed&sed=justo&vel=pellentesque&enim=viverra&sit=pede&amet=ac&nunc=diam&viverra=cras&dapibus=pellentesque&nulla=volutpat&suscipit=dui&ligula=maecenas&in=tristique&lacus=est&curabitur=et&at=tempus&ipsum=semper&ac=est&tellus=quam&semper=pharetra&interdum=magna&mauris=ac&ullamcorper=consequat&purus=metus&sit=sapien&amet=ut&nulla=nunc&quisque=vestibulum&arcu=ante&libero=ipsum&rutrum=primis&ac=in&lobortis=faucibus&vel=orci&dapibus=luctus&at=et&diam=ultrices', 'Room 1169', 'Danell', 'dsimoneschio@163.com', '726-436-0949');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (26, 'Dynazzy', 'http://networksolutions.com/mauris/eget/massa/tempor/convallis.jsp?quam=vulputate&fringilla=luctus&rhoncus=cum&mauris=sociis&enim=natoque&leo=penatibus&rhoncus=et&sed=magnis&vestibulum=dis&sit=parturient&amet=montes&cursus=nascetur&id=ridiculus&turpis=mus&integer=vivamus&aliquet=vestibulum&massa=sagittis&id=sapien&lobortis=cum&convallis=sociis&tortor=natoque&risus=penatibus&dapibus=et&augue=magnis&vel=dis&accumsan=parturient&tellus=montes&nisi=nascetur&eu=ridiculus&orci=mus&mauris=etiam&lacinia=vel&sapien=augue&quis=vestibulum&libero=rutrum&nullam=rutrum&sit=neque&amet=aenean&turpis=auctor&elementum=gravida&ligula=sem&vehicula=praesent&consequat=id&morbi=massa&a=id&ipsum=nisl&integer=venenatis', 'Suite 34', 'Clareta', 'cantyshevp@columbia.edu', '500-104-9278');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (27, 'Livepath', 'http://vkontakte.ru/sed/lacus/morbi.html?id=montes&turpis=nascetur&integer=ridiculus&aliquet=mus&massa=etiam&id=vel&lobortis=augue&convallis=vestibulum&tortor=rutrum&risus=rutrum&dapibus=neque&augue=aenean&vel=auctor&accumsan=gravida&tellus=sem&nisi=praesent&eu=id', 'PO Box 34318', 'Goldie', 'gcasariq@etsy.com', '496-710-6277');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (28, 'Wordpedia', 'http://un.org/magna.jpg?vitae=fermentum&quam=donec&suspendisse=ut&potenti=mauris&nullam=eget&porttitor=massa&lacus=tempor&at=convallis&turpis=nulla&donec=neque&posuere=libero&metus=convallis&vitae=eget&ipsum=eleifend&aliquam=luctus&non=ultricies&mauris=eu&morbi=nibh&non=quisque&lectus=id&aliquam=justo&sit=sit&amet=amet&diam=sapien&in=dignissim&magna=vestibulum&bibendum=vestibulum&imperdiet=ante&nullam=ipsum&orci=primis&pede=in&venenatis=faucibus&non=orci&sodales=luctus&sed=et&tincidunt=ultrices&eu=posuere&felis=cubilia&fusce=curae&posuere=nulla&felis=dapibus&sed=dolor', 'Room 191', 'Ky', 'kbutterwickr@salon.com', '668-778-2090');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (29, 'Thoughtblab', 'https://goodreads.com/mattis/nibh/ligula.html?cras=aliquam&pellentesque=non&volutpat=mauris&dui=morbi&maecenas=non&tristique=lectus&est=aliquam&et=sit&tempus=amet&semper=diam&est=in&quam=magna&pharetra=bibendum&magna=imperdiet&ac=nullam&consequat=orci&metus=pede&sapien=venenatis&ut=non&nunc=sodales&vestibulum=sed&ante=tincidunt&ipsum=eu&primis=felis&in=fusce&faucibus=posuere&orci=felis&luctus=sed&et=lacus&ultrices=morbi&posuere=sem&cubilia=mauris&curae=laoreet&mauris=ut&viverra=rhoncus&diam=aliquet&vitae=pulvinar&quam=sed&suspendisse=nisl&potenti=nunc&nullam=rhoncus&porttitor=dui&lacus=vel&at=sem&turpis=sed&donec=sagittis&posuere=nam&metus=congue&vitae=risus&ipsum=semper', 'Room 1026', 'Thibaud', 'tlambillions@blogger.com', '923-539-8457');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (30, 'Skibox', 'https://hao123.com/quisque/arcu/libero/rutrum/ac.aspx?nisl=quis&nunc=turpis&nisl=sed&duis=ante&bibendum=vivamus&felis=tortor&sed=duis&interdum=mattis&venenatis=egestas&turpis=metus&enim=aenean&blandit=fermentum&mi=donec&in=ut&porttitor=mauris&pede=eget&justo=massa&eu=tempor&massa=convallis&donec=nulla&dapibus=neque&duis=libero&at=convallis&velit=eget&eu=eleifend&est=luctus&congue=ultricies&elementum=eu&in=nibh&hac=quisque&habitasse=id&platea=justo&dictumst=sit&morbi=amet&vestibulum=sapien&velit=dignissim&id=vestibulum&pretium=vestibulum&iaculis=ante&diam=ipsum&erat=primis&fermentum=in&justo=faucibus&nec=orci&condimentum=luctus&neque=et&sapien=ultrices&placerat=posuere&ante=cubilia&nulla=curae&justo=nulla&aliquam=dapibus&quis=dolor&turpis=vel&eget=est&elit=donec&sodales=odio&scelerisque=justo&mauris=sollicitudin&sit=ut&amet=suscipit&eros=a&suspendisse=feugiat&accumsan=et&tortor=eros&quis=vestibulum&turpis=ac&sed=est&ante=lacinia&vivamus=nisi&tortor=venenatis&duis=tristique&mattis=fusce&egestas=congue&metus=diam&aenean=id&fermentum=ornare&donec=imperdiet&ut=sapien&mauris=urna&eget=pretium&massa=nisl&tempor=ut&convallis=volutpat&nulla=sapien&neque=arcu&libero=sed&convallis=augue&eget=aliquam&eleifend=erat&luctus=volutpat&ultricies=in&eu=congue&nibh=etiam&quisque=justo&id=etiam', '2nd Floor', 'Cleavland', 'ckirlint@themeforest.net', '173-849-3166');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (31, 'Browsezoom', 'https://sohu.com/erat.js?quisque=posuere&id=cubilia&justo=curae&sit=nulla&amet=dapibus&sapien=dolor&dignissim=vel&vestibulum=est&vestibulum=donec&ante=odio&ipsum=justo&primis=sollicitudin&in=ut&faucibus=suscipit&orci=a&luctus=feugiat&et=et&ultrices=eros&posuere=vestibulum&cubilia=ac&curae=est&nulla=lacinia&dapibus=nisi&dolor=venenatis&vel=tristique&est=fusce&donec=congue&odio=diam&justo=id&sollicitudin=ornare&ut=imperdiet&suscipit=sapien&a=urna&feugiat=pretium&et=nisl&eros=ut&vestibulum=volutpat&ac=sapien&est=arcu&lacinia=sed&nisi=augue&venenatis=aliquam&tristique=erat&fusce=volutpat&congue=in&diam=congue&id=etiam&ornare=justo&imperdiet=etiam&sapien=pretium&urna=iaculis', 'Apt 1434', 'Reed', 'rgellanu@nsw.gov.au', '497-241-4539');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (32, 'Cogilith', 'http://friendfeed.com/sapien.aspx?ut=eget&erat=nunc&id=donec&mauris=quis&vulputate=orci&elementum=eget&nullam=orci&varius=vehicula&nulla=condimentum&facilisi=curabitur&cras=in&non=libero&velit=ut&nec=massa&nisi=volutpat&vulputate=convallis&nonummy=morbi&maecenas=odio&tincidunt=odio&lacus=elementum&at=eu&velit=interdum&vivamus=eu&vel=tincidunt&nulla=in&eget=leo&eros=maecenas&elementum=pulvinar&pellentesque=lobortis&quisque=est&porta=phasellus&volutpat=sit&erat=amet&quisque=erat&erat=nulla', 'Apt 1559', 'Carmine', 'cseiffertv@engadget.com', '866-957-2399');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (33, 'Flipbug', 'https://wordpress.com/elementum/pellentesque/quisque/porta/volutpat/erat/quisque.html?velit=et&id=ultrices&pretium=posuere&iaculis=cubilia&diam=curae&erat=donec&fermentum=pharetra&justo=magna&nec=vestibulum&condimentum=aliquet&neque=ultrices&sapien=erat&placerat=tortor&ante=sollicitudin&nulla=mi&justo=sit&aliquam=amet&quis=lobortis&turpis=sapien&eget=sapien&elit=non&sodales=mi&scelerisque=integer&mauris=ac', 'Suite 17', 'Harlen', 'hsherebrookw@state.tx.us', '756-784-2510');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (34, 'Aivee', 'https://studiopress.com/odio/odio/elementum.json?volutpat=ultrices&dui=posuere&maecenas=cubilia&tristique=curae&est=duis&et=faucibus&tempus=accumsan&semper=odio&est=curabitur&quam=convallis&pharetra=duis&magna=consequat&ac=dui&consequat=nec&metus=nisi&sapien=volutpat&ut=eleifend&nunc=donec&vestibulum=ut&ante=dolor&ipsum=morbi&primis=vel&in=lectus&faucibus=in&orci=quam&luctus=fringilla&et=rhoncus&ultrices=mauris&posuere=enim', 'Apt 1163', 'Bondie', 'btalloex@theguardian.com', '152-538-3001');
insert into Business (Biz_id, Biz_name, Website, Address, Owner_Name, Owner_Email, Owner_Phone) values (35, 'Roombo', 'https://jigsy.com/volutpat/erat/quisque/erat.png?cum=potenti&sociis=in&natoque=eleifend&penatibus=quam&et=a&magnis=odio&dis=in&parturient=hac&montes=habitasse&nascetur=platea&ridiculus=dictumst&mus=maecenas&etiam=ut&vel=massa&augue=quis&vestibulum=augue&rutrum=luctus&rutrum=tincidunt&neque=nulla&aenean=mollis&auctor=molestie&gravida=lorem&sem=quisque&praesent=ut&id=erat&massa=curabitur&id=gravida&nisl=nisi&venenatis=at&lacinia=nibh&aenean=in&sit=hac&amet=habitasse&justo=platea&morbi=dictumst&ut=aliquam&odio=augue&cras=quam&mi=sollicitudin&pede=vitae&malesuada=consectetuer&in=eget&imperdiet=rutrum&et=at&commodo=lorem', '7th Floor', 'Tades', 'tbarabichy@mit.edu', '505-648-2214');

-- Student Data
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (1, 27, 'Herc', 'Vaun', 'hvaun0', 'hvaun0@nifty.com', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2011, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (2, 70, 'Reuben', 'Thunderman', 'rthunderman1', 'rthunderman1@deliciousdays.com', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2000, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (3, 91, 'Willi', 'Jesteco', 'wjesteco2', 'wjesteco2@soup.io', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1986, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (4, 19, 'Dian', 'Strickett', 'dstrickett3', 'dstrickett3@tmall.com', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2000, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (5, 80, 'Roxine', 'Dorey', 'rdorey4', 'rdorey4@house.gov', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2004, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (6, 51, 'Gradeigh', 'Broggetti', 'gbroggetti5', 'gbroggetti5@discovery.com', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 2006, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (7, 81, 'Lyn', 'Bugg', 'lbugg6', 'lbugg6@phoca.cz', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 2008, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (8, 80, 'Teddie', 'Musgrove', 'tmusgrove7', 'tmusgrove7@umich.edu', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 2007, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (9, 42, 'Fleurette', 'Sawell', 'fsawell8', 'fsawell8@dailymotion.com', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 1966, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (10, 64, 'Oralee', 'Meatcher', 'omeatcher9', 'omeatcher9@wordpress.com', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 2004, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (11, 95, 'Ab', 'Paye', 'apayea', 'apayea@columbia.edu', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 1997, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (12, 50, 'Shannon', 'Kibel', 'skibelb', 'skibelb@buzzfeed.com', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1996, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (13, 76, 'Bordie', 'Brommage', 'bbrommagec', 'bbrommagec@yahoo.co.jp', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2011, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (14, 100, 'Cristian', 'Giovanitti', 'cgiovanittid', 'cgiovanittid@cbc.ca', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1988, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (15, 66, 'Fons', 'Stealfox', 'fstealfoxe', 'fstealfoxe@uol.com.br', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2011, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (16, 34, 'Bernhard', 'Ashbolt', 'bashboltf', 'bashboltf@com.com', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1993, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (17, 23, 'Dermot', 'Chiplin', 'dchipling', 'dchipling@tripadvisor.com', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 1996, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (18, 67, 'Carmon', 'Perot', 'cperoth', 'cperoth@hostgator.com', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 1998, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (19, 86, 'Reider', 'Mateos', 'rmateosi', 'rmateosi@google.com', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 1996, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (20, 30, 'Lorain', 'Spur', 'lspurj', 'lspurj@columbia.edu', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 1999, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (21, 34, 'Monte', 'Gosker', 'mgoskerk', 'mgoskerk@kickstarter.com', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2004, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (22, 13, 'Roderic', 'Tynemouth', 'rtynemouthl', 'rtynemouthl@wikipedia.org', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2003, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (23, 36, 'Ivan', 'Crowch', 'icrowchm', 'icrowchm@ucsd.edu', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 1995, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (24, 83, 'Chrotoem', 'Piburn', 'cpiburnn', 'cpiburnn@parallels.com', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2009, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (25, 36, 'Benedicto', 'Cusiter', 'bcusitero', 'bcusitero@examiner.com', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 1991, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (26, 58, 'Benyamin', 'Losebie', 'blosebiep', 'blosebiep@wordpress.com', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 1992, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (27, 53, 'Chelsie', 'Beacock', 'cbeacockq', 'cbeacockq@netlog.com', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 2005, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (28, 7, 'Georgie', 'Broadstock', 'gbroadstockr', 'gbroadstockr@csmonitor.com', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 1993, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (29, 28, 'Ferd', 'De Giorgio', 'fdegiorgios', 'fdegiorgios@mapquest.com', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 1996, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (30, 85, 'Linus', 'Legging', 'lleggingt', 'lleggingt@csmonitor.com', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 2007, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (31, 16, 'Karyn', 'Rizzo', 'krizzou', 'krizzou@abc.net.au', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 2005, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (32, 43, 'Dolli', 'Huddleston', 'dhuddlestonv', 'dhuddlestonv@xrea.com', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2009, false);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (33, 35, 'Juan', 'Corrado', 'jcorradow', 'jcorradow@omniture.com', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2008, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (34, 88, 'Wally', 'MacKinnon', 'wmackinnonx', 'wmackinnonx@yellowbook.com', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1995, true);
insert into Business (Student_Id, Uni_Id, First_Name, Last_Name, Username, Student_Email, Student_Type, Grad_Year, Verified_Status) values (35, 3, 'Devan', 'Ashman', 'dashmany', 'dashmany@cbslocal.com', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 2003, true);

-- Business_Owner Data
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (1, 96, 30, 'Tamas Roelvink', 'troelvink0@wsj.com', '341-743-8615');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (2, 66, 29, 'Ferrell McElwee', 'fmcelwee1@tinypic.com', '809-806-7006');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (3, 64, 49, 'Nancy Lundbeck', 'nlundbeck2@irs.gov', '100-144-7062');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (4, 2, 67, 'Norine Boumphrey', 'nboumphrey3@cyberchimps.com', '621-876-3960');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (5, 38, 42, 'Natassia Iggo', 'niggo4@fotki.com', '378-855-9295');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (6, 63, 51, 'Agnese Schollick', 'aschollick5@mysql.com', '511-441-3606');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (7, 87, 72, 'Steffen Martygin', 'smartygin6@aol.com', '250-193-6626');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (8, 96, 42, 'Josefa Rous', 'jrous7@cargocollective.com', '401-720-7049');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (9, 88, 83, 'Toni Gasnoll', 'tgasnoll8@businesswire.com', '400-931-9701');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (10, 39, 10, 'Huberto Jimmes', 'hjimmes9@columbia.edu', '219-613-0794');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (11, 40, 63, 'Hugues Breston', 'hbrestona@rediff.com', '384-553-8325');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (12, 13, 12, 'Genevieve Killgus', 'gkillgusb@psu.edu', '127-278-8119');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (13, 72, 93, 'Timi McGiffie', 'tmcgiffiec@sciencedaily.com', '954-468-2330');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (14, 25, 28, 'Celie Keggins', 'ckegginsd@cdbaby.com', '428-508-5356');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (15, 20, 51, 'Daisi Kobke', 'dkobkee@rambler.ru', '791-258-7249');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (16, 25, 92, 'Lilith Eisak', 'leisakf@themeforest.net', '517-217-4714');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (17, 39, 66, 'Lorant Etock', 'letockg@accuweather.com', '530-307-5433');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (18, 65, 32, 'Dara Kesterton', 'dkestertonh@spotify.com', '916-183-5168');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (19, 1, 80, 'Alis Gerleit', 'agerleiti@sakura.ne.jp', '378-236-3883');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (20, 32, 48, 'Orelle Barniss', 'obarnissj@newsvine.com', '825-843-9371');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (21, 91, 56, 'Cordy Heinritz', 'cheinritzk@networksolutions.com', '511-220-6728');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (22, 76, 33, 'Greggory Boxer', 'gboxerl@shareasale.com', '301-646-8028');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (23, 27, 43, 'Isac Crum', 'icrumm@opensource.org', '153-735-1506');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (24, 66, 75, 'Eugene Baterip', 'ebateripn@mozilla.com', '448-188-3709');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (25, 39, 32, 'Brok Mesias', 'bmesiaso@phpbb.com', '984-517-4031');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (26, 65, 99, 'Hilde Tomaszczyk', 'htomaszczykp@sfgate.com', '901-324-0945');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (27, 64, 88, 'Nettie Scolts', 'nscoltsq@privacy.gov.au', '418-901-3186');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (28, 29, 79, 'Graehme Lillicrap', 'glillicrapr@google.ca', '198-333-1871');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (29, 64, 69, 'Boy Rodgman', 'brodgmans@ucsd.edu', '315-888-3406');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (30, 42, 95, 'Sutton Gilligan', 'sgilligant@microsoft.com', '482-764-1667');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (31, 45, 3, 'Morgan McKinnon', 'mmckinnonu@home.pl', '313-396-8868');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (32, 50, 9, 'Bartie Ryburn', 'bryburnv@ed.gov', '979-137-3323');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (33, 7, 25, 'Marji Shyres', 'mshyresw@feedburner.com', '318-814-3608');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (34, 36, 89, 'Marji Littlepage', 'mlittlepagex@state.gov', '613-122-2669');
insert into Business_Owner (Owner_Id, Biz_Id, Uni_Id, Owner_Name, Owner_Email, Owner_Phone) values (35, 97, 11, 'Heath Glasner', 'hglasnery@squidoo.com', '217-651-3057');


-- Discounts 
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (1, 1, '20% Off Large Pizzas', 20, true, '1/10/2026', 'PIZZA20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (2, 1, 'Buy 2 Get 1 Free Burgers', 33, true, '2/14/2026', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (3, 1, 'Free Garlic Bread with Any Order', 0, false, '12/1/2025', 'GARLIC100');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (4, 2, '15% Off All Textbooks', 15, true, '1/15/2026', 'BOOKS15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (5, 2, 'Student Meal Deal - $5 Off', 5, true, '2/1/2026', 'MEAL5');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (6, 3, '10% Off First Haircut', 10, true, '1/20/2026', 'FIRSTCUT10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (7, 3, 'Half-Price Blowout Tuesdays', 50, true, '3/1/2026', 'BLOWOUT50');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (8, 4, '$20 Off Any Gym Membership', 20, true, '2/10/2026', 'GYM20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (9, 4, 'Free Week Trial - Yoga Studio', 100, false, '11/15/2025', 'YOGAFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (10, 5, '25% Off Vintage Tees', 25, true, '3/5/2026', 'TEES25');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (11, 5, 'Spend $50 Save $10', 10, true, '1/25/2026', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (12, 6, '$15 Off Oil Change', 15, true, '2/20/2026', 'OIL15');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (13, 6, 'Free Tire Rotation with Service', 0, true, '3/10/2026', 'TIREFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (14, 7, '30% Off All Smoothies', 30, true, '2/28/2026', 'SMOOTH30');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (15, 7, 'Buy 1 Juice Get 1 50% Off', 50, false, '12/20/2025', 'JUICE50');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (16, 8, '20% Off Movie Tickets Online', 20, true, '1/5/2026', 'MOVIE20');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (17, 8, 'Tuesday $5 Admission', 5, true, '3/15/2026', null);
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (18, 9, '$10 Off Print Orders Over $30', 10, true, '2/5/2026', 'PRINT10');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (19, 9, 'Free Lamination with Any Order', 0, false, '11/1/2025', 'LAMIFREE');
insert into Discount (Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code) values (20, 10, '40% Off Seasonal Menu Items', 40, true, '3/20/2026', 'SEASON40');


-- Saved_Discount
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (1, 1, '3/1/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (2, 2, '3/5/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (3, 5, '1/7/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (4, 8, '1/14/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (5, 3, '1/19/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (6, 12, '1/23/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (7, 7, '1/26/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (8, 15, '2/1/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (9, 4, '2/10/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (10, 10, '2/11/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (11, 6, '2/15/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (12, 18, '2/19/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (13, 9, '2/20/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (14, 14, '2/25/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (15, 2, '2/27/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (16, 20, '3/1/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (17, 11, '3/9/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (18, 16, '3/12/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (19, 13, '3/18/2026');
insert into Saved_Discount (Student_Id, Discount_Id, Saved_At) values (20, 17, '3/28/2026');


-- Shared_Discount
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (2, 1, 1, '3/2/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (1, 3, 2, '3/6/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (4, 2, 5, '1/8/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (3, 5, 8, '1/15/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (6, 4, 3, '2/1/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (5, 7, 12, '2/9/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (8, 6, 7, '2/14/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (7, 9, 15, '2/20/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (10, 8, 4, '2/25/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (9, 11, 10, '3/1/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (12, 10, 6, '3/5/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (11, 13, 18, '3/8/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (14, 12, 9, '3/11/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (13, 15, 14, '3/14/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (16, 14, 2, '3/17/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (15, 17, 20, '3/19/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (18, 16, 11, '3/21/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (17, 19, 16, '3/23/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (20, 18, 13, '3/26/2026');
insert into Shared_Discount (Sender_Id, Receiver_Id, Discount_Id, Shared_At) values (19, 20, 17, '3/29/2026');
