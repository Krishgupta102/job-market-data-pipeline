-- =========================================================
-- JOB MARKET DATA PIPELINE - ANALYTICAL QUERIES
-- =========================================================


-- 1. Jobs by Industry
SELECT
    i.industry_name,
    COUNT(*) AS job_count
FROM fact_job_postings f
JOIN dim_industry i
    ON f.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY job_count DESC
LIMIT 15;


-- 2. Jobs by Job Type
SELECT
    jt.job_type,
    COUNT(*) AS job_count
FROM fact_job_postings f
JOIN dim_job_type jt
    ON f.job_type_id = jt.job_type_id
GROUP BY jt.job_type
ORDER BY job_count DESC;


-- 3. Top Locations
SELECT
    l.location,
    COUNT(*) AS job_count
FROM fact_job_postings f
JOIN dim_location l
    ON f.location_id = l.location_id
WHERE l.location_id != 0
GROUP BY l.location
ORDER BY job_count DESC
LIMIT 15;


-- 4. Salary Statistics
SELECT
    salary_period,
    COUNT(*) AS jobs_with_salary,
    ROUND(AVG(salary_min), 2) AS avg_min_salary,
    ROUND(AVG(salary_max), 2) AS avg_max_salary,
    MIN(salary_min) AS lowest_salary,
    MAX(salary_max) AS highest_salary
FROM fact_job_postings
WHERE salary_min IS NOT NULL
   OR salary_max IS NOT NULL
GROUP BY salary_period
ORDER BY jobs_with_salary DESC;


-- 5. Top Job Roles
SELECT
    r.role_name,
    COUNT(*) AS job_count
FROM fact_job_postings f
JOIN dim_role r
    ON f.role_id = r.role_id
WHERE r.role_id != 0
GROUP BY r.role_name
ORDER BY job_count DESC
LIMIT 20;

-- 6. Industry + Job Type Analysis
SELECT
    i.industry_name,
    jt.job_type,
    COUNT(*) AS job_count
FROM fact_job_postings f
JOIN dim_industry i
    ON f.industry_id = i.industry_id
JOIN dim_job_type jt
    ON f.job_type_id = jt.job_type_id
GROUP BY
    i.industry_name,
    jt.job_type
ORDER BY job_count DESC
LIMIT 20;

-- 7. Salary by Industry
SELECT
    i.industry_name,
    COUNT(*) AS jobs_with_salary,
    ROUND(AVG(f.salary_min), 2) AS avg_min_salary,
    ROUND(AVG(f.salary_max), 2) AS avg_max_salary
FROM fact_job_postings f
JOIN dim_industry i
    ON f.industry_id = i.industry_id
WHERE f.salary_min IS NOT NULL
   OR f.salary_max IS NOT NULL
GROUP BY i.industry_name
HAVING COUNT(*) >= 10
ORDER BY avg_max_salary DESC
LIMIT 20;