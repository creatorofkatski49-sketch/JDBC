-- Run this in Supabase → SQL Editor
-- =============================================
-- Student Management System - Database Setup
-- =============================================

-- 1. Create the students table
CREATE TABLE IF NOT EXISTS students (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    course     VARCHAR(50)  NOT NULL,
    year_level VARCHAR(20)  NOT NULL
);

-- 2. (Optional) Insert some sample data to verify the connection
INSERT INTO students (name, course, year_level) VALUES
    ('Juan dela Cruz',   'BSCS',  '1st Year'),
    ('Maria Santos',     'BSIT',  '2nd Year'),
    ('Jose Reyes',       'BSEE',  '3rd Year'),
    ('Ana Gonzales',     'BSME',  '4th Year');

-- 3. Verify the data
SELECT * FROM students;
