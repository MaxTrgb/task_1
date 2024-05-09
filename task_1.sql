CREATE TABLE departments (
	id SERIAL PRIMARY KEY NOT NULL,
	building int NOT NULL CHECK (building > 0 AND building < 6),
	name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE wards (
	id SERIAL PRIMARY KEY NOT NULL,
	name varchar(20) NOT NULL UNIQUE,
	places int NOT NULL CHECK (places > 0),
	department_id int NOT NULL,
	
	FOREIGN KEY(department_id) REFERENCES departments(id)
);

CREATE TABLE doctors (
	id SERIAL PRIMARY KEY NOT NULL,	
	name varchar(255) NOT NULL,
	surname varchar(255) NOt NULL,
	salary int NOT NULL CHECK (salary > 0),
	premium int	NOT NULL DEFAULT 0 CHECK (premium >= 0) 
);

CREATE TABLE examinations(
	id SERIAL PRIMARY KEY NOT NULL,	
	name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE doctors_examinations(
	id SERIAL PRIMARY KEY NoT NULL,	
	end_time int NOT NULL CHECK(end_time > start_time),
	start_time int NOT NULL CHECK (start_time >= 8 AND start_time <= 18),
	doctor_id int NOT NULL,
	examination_id int NOT NULL,
	ward_id int NOT NULL,	
	FOREIGN KEY(doctor_id) REFERENCES doctors(id),
	FOREIGN KEY(examination_id) REFERENCES examinations(id),
	FOREIGN KEY(ward_id) REFERENCES wards(id)	
);

CREATE TABLE sponsors (
	id SERIAL PRIMARY KEY NOT NULL,
	name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE donations (
	id SERIAL PRIMARY KEY NOT NULL,
	amount int NOT NULL CHECK (amount >0),
	donation_date date NOT NULL CHECK(donation_date <= CURRENT_DATE),
	department_id int NOT NULL,
	sponsor_id int NOT NULL,
	FOREIGN KEY (sponsor_id) REFERENCES sponsors(id),
	FOREIGN KEY(department_id) REFERENCES departments(id)	
);

INSERT INTO departments(building, name) VALUES
(1, 'emergency'),
(2, 'cardiology'),
(3, 'pediatric'),
(4, 'neurology'),
(5, 'radiology'),
(3, 'stomatology'),
(1, 'infections')
;


INSERT INTO wards(name, places, department_id) VALUES
('ward1', 1, 1),
('ward2', 2, 2),
('ward3', 3, 1),
('ward4', 2, 2),
('ward5', 4, 3),
('ward6', 3, 3),
('ward7', 2, 1),
('ward8', 1, 4),
('ward9', 4, 4),
('ward10', 3, 4),
('ward11', 2, 4),
('ward12', 1, 5),
('ward13', 2, 5),
('ward14', 3, 5)
;

INSERT INTO doctors(name, surname, salary, premium) VALUES
('Greg', 'House', 200000, 2000),
('Eric', 'Foreman', 110000, 2000),
('Robert', 'Chase', 100000, 2000),
('Allison', 'Cameron', 120000, 1000),
('Lisa', 'Caddy', 170000, 1500),
('James', 'Willson', 80000, 1000)
;
INSERT INTO examinations (name) VALUES
('General Checkup'),
('MRI Scan'),
('Echocardiogram');

INSERT INTO doctors_examinations (end_time, start_time, doctor_id, examination_id, ward_id) VALUES
(15, 12, 1, 1, 1),
(15, 13, 2, 2, 2),
(14, 9, 3, 3, 3),
(16, 11, 4, 1, 4),
(13, 9, 5, 2, 5),
(17, 12, 6, 3, 6);

INSERT INTO sponsors(name) VALUES 
('Coca-Cola'),
('Pepsi'),
('Snikers'),
('Apple'),
('Lamborgini');

INSERT INTO donations(amount, donation_date, department_id, sponsor_id) VALUES
(500000, '2020-08-11', 2, 1),
(200000, '2022-07-21', 3, 2),
(300000, '2019-06-22', 7, 3),
(1000000, '2015-05-10', 6, 4),
(5000000, '2023-09-01', 6, 1),
(2000000, '2022-12-03', 5, 2),
(550000, '2021-08-07', 4, 3),
(100000, '2016-02-08', 3, 4),
(150000, '2021-11-09', 2, 2),
(280000, '2020-01-01', 1, 2);

--1.Вивести назви відділень, що знаходяться у тому ж корпусі, що й відділення “emergency”

SELECT name 
FROM departments
WHERE departments.building IN (1);


--2.Вивести назви відділень, що знаходяться у тому ж корпусі, що й відділення “emergency” та “pediatric”

SELECT name 
FROM departments
WHERE departments.building IN (1, 3);


--3.Вивести назву відділення, яке отримало найменше пожертвувань.


SELECT name, COUNT(*)
FROM donations
JOIN departments
on department_id = departments.id
GROUP BY departments.name
ORDER BY COUNT(*)
LIMIT 1;



--4. Вивести прізвища лікарів, ставка яких більша, ніж у лікаря “Allison Cameron”

SELECT name, surname 
FROM doctors
WHERE doctors.salary > (SELECT salary+premium FROM doctors WHERE name = 'Allison' AND surname = 'Cameron');



--5. Вивести назви палат, місткість яких більша, ніж середня місткість у палатах відділення “neurology”

SELECT departments.name
FROM departments
JOIN wards ON department_id = departments.id
GROUP BY departments.name
HAVING AVG(wards.places) > (SELECT AVG(wards.places) FROM wards WHERE department_id = 4);




--6. Вивести повні імена лікарів, зарплати яких перевищують більш ніж на 100 зарплату лікаря “Allison Cameron”

SELECT name, surname
FROM doctors
WHERE doctors.salary > (SELECT salary+premium+100 FROM doctors WHERE name = 'Allison' AND surname = 'Cameron');



--7. Вивести назви відділень, у яких проводить обстеження лікар Greg House

SELECT departments.name
FROM departments
JOIN wards ON department_id = departments.id
JOIN doctors_examinations ON ward_id = wards.id
JOIN doctors ON doctor_id = doctors.id
WHERE doctors.name = 'Greg' AND doctors.surname = 'House';

--8. Вивести назви спонсорів, які не робили пожертвування відділенням “emergency” та “radiology”

SELECT DISTINCT sponsors.name
FROM sponsors
LEFT JOIN donations ON sponsors.id = donations.sponsor_id
LEFT JOIN departments ON donations.department_id = departments.id AND departments.name IN ('emergency', 'radiology')
WHERE departments.id IS NULL;



--9. Вивести прізвища лікарів, які проводять обстеження у період з 12:00 до 15:00

SELECT surname
FROM doctors
JOIN doctors_examinations ON doctor_id = doctors.id
WHERE start_time = 12 AND end_time = 15;













