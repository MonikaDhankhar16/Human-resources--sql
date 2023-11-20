select * from hr;
-- Data cleaning 
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

-- birthdate is text,so we have to change its datatype
SELECT birthdate FROM hr;


SET sql_safe_updates = 0;

SET sql_mode = 'NO_ZERO_DATE';

UPDATE hr
SET birthdate = NULLIF(birthdate, ''),
    birthdate = NULLIF(birthdate, '0000-00-00'),
    birthdate = NULLIF(birthdate, '0000/00/00'),
    birthdate = NULLIF(birthdate, '00/00/0000'),
    birthdate = NULLIF(birthdate, '00-00-0000');

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SET sql_mode = '';

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
UPDATE hr
-- change dataype of hire_date column
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- change dataype of termdate columnUPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr ADD COLUMN age INT;
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

select birthdate, age from hr;