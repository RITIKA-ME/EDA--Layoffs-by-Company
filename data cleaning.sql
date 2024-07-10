SELECT * FROM world_layoffs.layoffsss;

-- Data Cleaning
-- 1. Remove Dupllicates
-- 2. Standardize The Data
-- 3. Remove Null Values
-- 4. Remove any columns

CREATE TABLE layoffs_staging
LIKE layoffsss;


SELECT *
FROM layoffs_staging;


INSERT INTO layoffs_staging
SELECT *
FROM LAYOFFSSS;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,DATE) AS ROW_NUM
FROM layoffs_staging;

WITH DUPLICATE_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,DATE,STAGE,COUNTRY,funds_raised_millions) AS ROW_NUM
FROM layoffs_staging )

SELECT*
FROM DUPLICATE_CTE
WHERE COMPANY = 'CASPER';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT  INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF,DATE,STAGE,COUNTRY,funds_raised_millions) AS ROW_NUM
FROM layoffs_staging ;


DELETE FROM
layoffs_staging2
WHERE ROW_NUM > 1;

SELECT *
FROM layoffs_staging2;


-- STANDARDIZING THE DATA
SELECT COMPANY, TRIM(COMPANY)
FROM layoffs_staging2;

UPDATE LAYOFFS_STAGING2
SET COMPANY = TRIM(COMPANY);


SELECT DISTINCT INDUSTRY
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM LAYOFFS_STAGING2
WHERE INDUSTRY LIKE 'CRYPTO%';


UPDATE LAYOFFS_STAGING2
SET INDUSTRY = 'CRYPTO'
WHERE INDUSTRY LIKE "Crypto%";

SELECT DISTINCT INDUSTRY
FROM LAYOFFS_STAGING2;

SELECT DISTINCT country
FROM LAYOFFS_STAGING2;

SELECT DISTINCT COUNTRY
FROM LAYOFFS_STAGING2;


UPDATE LAYOFFS_STAGING2
SET COUNTRY = 'United States'
WHERE COUNTRY LIKE 'UNITED STATES%';

select `date`,
str_to_date('date','%m/%d/%Y')
FROM LAYOFFS_STAGING2;



UPDATE LAYOFFS_STAGING2
SET `DATE`= str_to_date('date','%m/%d/%Y');

alter table layoffs_staging2
modify column `date` DATE;


SELECT *
FROM LAYOFFS_STAGING2
WHERE TOTAL_LAID_OFF IS NULL
 AND
PERCENTAGE_LAID_OFF IS NULL
;

SELECT *
FROM layoffs_staging2
WHERE INDUSTRY IS NULL OR INDUSTRY  = ''; 

select *
from layoffs_staging2
where COMPANY = 'AIRBNB';


SELECT *
FROM layoffs_staging2 T1
JOIN layoffs_staging2 T2
     ON T1.company = T2.COMPANY
     AND T1.LOCATION = T2.LOCATION
WHERE (T1.industry is null
or  t1.industry = '' ) and t2.industry is not null;

update layoffs_staging2 T1
JOIN layoffs_staging2 T2
    ON T1.COMPANY = T2.COMPANY
SET T1.INDUSTRY = T2.INDUSTRY
WHERE (T1.industry is null
or  t1.industry = '' ) and t2.industry is not null;











