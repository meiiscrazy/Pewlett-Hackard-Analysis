CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

SELECT * FROM departments;

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

SELECT * FROM employees;

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_manager;

CREATE TABLE salaries (
  	emp_no INT NOT NULL,
  	salary INT NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (emp_no)
);

SELECT * FROM salaries;

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM titles;

-- Importing files (mac method)
COPY departments FROM '/Users/mei/Public/departments.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM '/Users/mei/Public/employees.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM '/Users/mei/Public/dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY dept_manager FROM '/Users/mei/Public/dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM '/Users/mei/Public/salaries.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM '/Users/mei/Public/titles.csv' DELIMITER ',' CSV HEADER;

SELECT e.emp_no,
e.birth_date,
e.first_name,
e.last_name,
s.salary,
s.from_date
FROM employees AS e
INNER JOIN salaries as s ON 
e.emp_no = s.emp_no;

CREATE TABLE employee_title (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	title VARCHAR NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
-- CHALLENGE MODULE 7
-- Deliverable 1
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date,
	s.salary
INTO employee_title
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31');

SELECT * FROM employee_title;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	title,
	to_date,
	salary
INTO new_retire
FROM
 (SELECT emp_no,
	first_name,
	last_name,
	title,
  	to_date,
	salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM employee_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM new_retire;

SELECT COUNT (DISTINCT emp_no) FROM new_retire;

SELECT COUNT (title),title 
INTO title_retire
FROM new_retire
GROUP BY title
ORDER BY count;

SELECT * FROM title_retire

-- Delivarble 2 Dept_emp, Employee, Title
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	de.dept_no,
	ti.title,
	de.from_date,
	de.to_date
INTO mentor
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

SELECT * FROM mentor;
SELECT COUNT (DISTINCT emp_no) FROM mentor;
