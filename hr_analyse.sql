-- Q1  What is the gender breakdown of employees in the company?
SELECT gender, count(*) AS count
FROM hr
WHERE age>=18 AND termdate='0000-00-00'
Group By gender;

-- What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;

--  What is the age distribution of employees in the company?
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate='0000-00-00';

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group,gender, 
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group,gender
ORDER BY age_group,gender;

-- Q4 How many employees work at headquarters versus remote locations?

SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location;

-- Q5What is the average length of employment for employees who have been terminated?

SELECT ROUND(AVG(DATEDIFF(termdate, hire_date)),0)/365 AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() AND age >= 18;

-- How does the gender distribution vary across departments?
SELECT department, gender, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department;

-- Q7 What is the distribution of job titles across the company
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;


-- Q8 Which department has the highest turnover rate?
SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

-- Q9 What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

-- q10 How has the company's employee count changed over time based on hire and term dates?
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
    
    
    -- Q 11. What is the tenure distribution for each department?

SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department