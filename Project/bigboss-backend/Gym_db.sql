CREATE DATABASE Gym_db;
USE Gym_db;

-- Members Table
CREATE TABLE Members (
  member_id VARCHAR(120) PRIMARY KEY,
  member_name VARCHAR(255),
  member_email VARCHAR(255),
  member_tel VARCHAR(15),
  dob DATE,
  join_date DATE,
  membership_type VARCHAR(50)
);

-- Trainers Table (5 rows total)
CREATE TABLE Trainers (
  trainer_id VARCHAR(120) PRIMARY KEY,
  trainer_name VARCHAR(255),
  specialty VARCHAR(255),
  bio TEXT
);

-- Class_Schedule Table (5 rows total)
CREATE TABLE Class_Schedule (
  class_id VARCHAR(120) PRIMARY KEY,
  class_name VARCHAR(255),
  trainer_id VARCHAR(120),
  start_time TIME,
  end_time TIME,
  days VARCHAR(255),
  FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- MembershipPlans Table
CREATE TABLE MembershipPlans (
  plan_id VARCHAR(120) PRIMARY KEY,
  plan_name VARCHAR(255),
  duration INT, -- in months
  price FLOAT,
  member_id VARCHAR(120),
  FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Payments Table
CREATE TABLE Payments (
  payment_id VARCHAR(120) PRIMARY KEY,
  member_id VARCHAR(120),
  amount FLOAT,
  payment_date DATETIME,
  payment_method VARCHAR(255),
  FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Equipment Table
CREATE TABLE Equipment (
  equipment_id VARCHAR(120) PRIMARY KEY,
  equipment_name VARCHAR(255),
  equipment_status VARCHAR(50),
  purchase_date DATE,
  last_maintenance DATE,
  class_id VARCHAR(120),
  FOREIGN KEY (class_id) REFERENCES Class_Schedule(class_id)
);

-- Special_Offers Table
CREATE TABLE Special_Offers (
  offer_id VARCHAR(120) PRIMARY KEY,
  offer_description TEXT,
  discount_rate DECIMAL(5,2),
  eligible_group VARCHAR(255),
  valid_until DATE,
  member_id VARCHAR(120),
  FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Attendance Table
CREATE TABLE Attendance (
  attendance_id VARCHAR(120) PRIMARY KEY,
  member_id VARCHAR(120),
  trainer_id VARCHAR(120),
  check_in DATETIME,
  check_out DATETIME,
  FOREIGN KEY (member_id) REFERENCES Members(member_id),
  FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- Feedback Table (5 rows total)
CREATE TABLE Feedback (
  feedback_id VARCHAR(120) PRIMARY KEY,
  member_id VARCHAR(120),
  trainer_id VARCHAR(120),
  comments TEXT,
  rating INT,
  feedback_data DATE,
  FOREIGN KEY (member_id) REFERENCES Members(member_id),
  FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- Shops Table
CREATE TABLE Shops (
  product_code VARCHAR(120) PRIMARY KEY, 
  category ENUM('Drinks', 'Café', 'Gym Equipment', 'Other'),
  product_name VARCHAR(255),
  description TEXT,
  price DECIMAL(10,2),
  stock_quantity INT DEFAULT 0,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  member_id VARCHAR(120),
  trainer_id VARCHAR(120),
  FOREIGN KEY (member_id) REFERENCES Members(member_id),
  FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- Cart Table
CREATE TABLE Cart (
  cart_id VARCHAR(120) PRIMARY KEY,
  member_id VARCHAR(120),
  product_code VARCHAR(120),
  quantity INT,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES Members(member_id),
  FOREIGN KEY (product_code) REFERENCES Shops(product_code)
);

ALTER TABLE Cart ADD COLUMN price DECIMAL(10,2);

------------------------------
-- Insert sample data below --
------------------------------

-- Members Data (5 rows)
INSERT INTO Members (member_id, member_name, member_email, member_tel, dob, join_date, membership_type)
VALUES 
  ('MBR001', 'Bun Ratnatepy', 'bunratnatepy@gmail.com', '011434668', '2003-11-12', '2025-01-01', 'Standard Membership'),
  ('MBR002', 'Alice Johnson', 'alice.johnson@example.com', '0123456789', '1990-05-15', '2025-02-01', 'Premium Membership'),
  ('MBR003', 'Bob Smith', 'bob.smith@example.com', '0987654321', '1985-07-20', '2025-03-01', 'Standard Membership'),
  ('MBR004', 'Carol White', 'carol.white@example.com', '0111122233', '1995-12-10', '2025-04-01', 'Standard Membership'),
  ('MBR005', 'David Green', 'david.green@example.com', '0223344556', '1992-09-09', '2025-05-01', 'Premium Membership');

-- Trainers Data (5 rows)
INSERT INTO Trainers (trainer_id, trainer_name, specialty, bio)
VALUES
  ('TRN001', 'Bun Ratnatepy', 'Yoga', 'Certified yoga instructor specializing in Vinyasa'),
  ('TRN002', 'Chhin Visal', 'Cardio', 'Expert in cardio training and endurance building'),
  ('TRN003', 'HAYSAVIN RONGRAVIDWIN', 'Strength Training', 'Strength enthusiast and coach with a focus on functional training'),
  ('TRN004', 'HOUN Sithai', 'Pilates', 'Professional Pilates instructor dedicated to core strength training'),
  -- New 5th trainer
  ('TRN005', 'Sokha Sam', 'CrossFit', 'Expert in CrossFit and high-intensity interval training');

-- Class_Schedule Data (5 rows)
INSERT INTO Class_Schedule (class_id, class_name, trainer_id, start_time, end_time, days)
VALUES
  ('CLS001', 'Morning Yoga', 'TRN001', '08:00:00', '09:00:00', 'Mon-Fri'),
  ('CLS002', 'Cardio Blast', 'TRN002', '07:00:00', '08:00:00', 'Mon-Sun'),
  ('CLS003', 'Evening Weightlifting', 'TRN003', '18:00:00', '19:30:00', 'Tue,Thu'),
  ('CLS004', 'Pilates Session', 'TRN004', '10:00:00', '11:00:00', 'Wed-Fri'),
  -- New 5th class to match CLS005 in Equipment
  ('CLS005', 'Advanced CrossFit', 'TRN005', '11:00:00', '12:00:00', 'Sat-Sun');

-- MembershipPlans Data (5 rows)
INSERT INTO MembershipPlans (plan_id, plan_name, duration, price, member_id)
VALUES
  ('PLAN001', 'Standard 6 Month', 6, 299.99, 'MBR001'),
  ('PLAN002', 'Premium 12 Month', 12, 499.99, 'MBR002'),
  ('PLAN003', 'Standard 3 Month', 3, 149.99, 'MBR003'),
  ('PLAN004', 'Premium 6 Month', 6, 349.99, 'MBR004'),
  ('PLAN005', 'Standard 12 Month', 12, 399.99, 'MBR005');

-- Payments Data (5 rows)
INSERT INTO Payments (payment_id, member_id, amount, payment_date, payment_method)
VALUES
  ('PAY001', 'MBR001', 299.99, '2025-01-05 10:00:00', 'Credit Card'),
  ('PAY002', 'MBR002', 499.99, '2025-02-10 11:00:00', 'Debit Card'),
  ('PAY003', 'MBR003', 149.99, '2025-03-15 12:00:00', 'Cash'),
  ('PAY004', 'MBR004', 349.99, '2025-04-20 09:30:00', 'Credit Card'),
  ('PAY005', 'MBR005', 399.99, '2025-05-25 14:00:00', 'Online Payment');

-- Equipment Data (5 rows)
INSERT INTO Equipment (equipment_id, equipment_name, equipment_status, purchase_date, last_maintenance, class_id)
VALUES
  ('EQP001', 'Treadmill', 'Active', '2024-06-01', '2025-01-10', 'CLS003'),
  ('EQP002', 'Bench Press', 'Active', '2024-07-15', '2025-02-12', 'CLS002'),
  ('EQP003', 'Yoga Mats', 'Active', '2024-08-20', '2025-03-05', 'CLS001'),
  ('EQP004', 'Dumbbells', 'Active', '2024-09-10', '2025-04-08', 'CLS004'),
  ('EQP005', 'Pilates Reformer', 'Active', '2024-10-05', '2025-05-12', 'CLS005');

-- Special_Offers Data (5 rows)
INSERT INTO Special_Offers (offer_id, offer_description, discount_rate, eligible_group, valid_until, member_id)
VALUES
  ('OFF001', '10% off for new members', 10.00, 'New Members', '2025-12-31', 'MBR001'),
  ('OFF002', '15% off for referrals', 15.00, 'Referred Members', '2025-11-30', 'MBR002'),
  ('OFF003', '20% off during summer', 20.00, 'Summer Special', '2025-08-31', 'MBR003'),
  ('OFF004', '5% discount for long term', 5.00, 'Loyal Members', '2026-01-31', 'MBR004'),
  ('OFF005', '25% off for premium upgrade', 25.00, 'Premium Members', '2025-09-30', 'MBR005');

-- Attendance Data (4 rows)
INSERT INTO Attendance (attendance_id, member_id, trainer_id, check_in, check_out)
VALUES
  ('ATT001', 'MBR001', 'TRN001', '2025-01-10 08:00:00', '2025-01-10 09:00:00'),
  ('ATT002', 'MBR002', 'TRN002', '2025-02-15 07:30:00', '2025-02-15 08:30:00'),
  ('ATT003', 'MBR003', 'TRN003', '2025-03-20 18:00:00', '2025-03-20 19:00:00'),
  ('ATT004', 'MBR004', 'TRN004', '2025-04-25 17:00:00', '2025-04-25 18:00:00');

-- Feedback Data (5 rows)
INSERT INTO Feedback (feedback_id, member_id, trainer_id, comments, rating, feedback_data)
VALUES
  ('FDB001', 'MBR001', 'TRN001', 'Very relaxing yoga class.', 4, '2025-02-16'),
  ('FDB002', 'MBR002', 'TRN002', 'Great session!', 5, '2025-01-11'),
  ('FDB003', 'MBR003', 'TRN003', 'Challenging but fun!', 5, '2025-03-21'),
  ('FDB004', 'MBR004', 'TRN004', 'Enjoyed the Pilates session.', 5, '2025-05-31'),
  -- New 5th feedback
  ('FDB005', 'MBR005', 'TRN005', 'CrossFit session was intense!', 5, '2025-06-10');

-- Shops Data (5 rows)
INSERT INTO Shops (product_code, category, product_name, description, price, stock_quantity, image_url, member_id, trainer_id)
VALUES
  ('PRD001', 'Drinks', 'Protein Shake', 'Delicious protein shake', 4.99, 100, 'http://example.com/protein_shake.jpg', 'MBR001', 'TRN001'),
  ('PRD002', 'Café', 'Coffee', 'Freshly brewed coffee', 2.50, 200, 'http://example.com/coffee.jpg', 'MBR002', 'TRN002'),
  ('PRD003', 'Gym Equipment', 'Yoga Mat', 'Non-slip yoga mat', 19.99, 50, 'http://example.com/yoga_mat.jpg', 'MBR003', 'TRN003'),
  ('PRD004', 'Other', 'Water Bottle', 'Reusable water bottle', 9.99, 150, 'http://example.com/water_bottle.jpg', 'MBR004', 'TRN004'),
  ('PRD005', 'Drinks', 'Green Tea', 'Refreshing green tea', 3.99, 120, 'http://example.com/green_tea.jpg', 'MBR005', 'TRN005');

-- Cart Data (5 rows)
INSERT INTO Cart (cart_id, member_id, product_code, quantity)
VALUES
  ('CRT001', 'MBR001', 'PRD001', 2),
  ('CRT002', 'MBR002', 'PRD002', 1),
  ('CRT003', 'MBR003', 'PRD003', 3),
  ('CRT004', 'MBR004', 'PRD004', 1),
  ('CRT005', 'MBR005', 'PRD005', 2);

-- Example query
SELECT * FROM Members
WHERE member_email = 'bunratnatepy@gmail.com'
  AND member_tel = '011434668';
