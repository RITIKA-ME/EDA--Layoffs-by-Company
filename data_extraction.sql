-- exploratory Data Analysis

select *
FROM layoffs_staging2;

SELECT MAX(TOTAL_LAID_OFF), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off =1
ORDER BY TOTAL_LAID_OFF DESC;


SELECT COMPANY, SUM(TOTAL_LAID_OFF)
FROM layoffs_staging2
GROUP BY COMPANY
ORDER BY 2 DESC;


SELECT MIN(`DATE`), MAX(`DATE`)
FROM layoffs_staging2;

SELECT INDUSTRY, SUM(TOTAL_LAID_OFF)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT YEAR(`DATE`),SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY YEAR (`DATE`) 
ORDER BY 1 DESC;


SELECT STAGE, SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY STAGE
ORDER BY 2 DESC;

SELECT substring(`DATE` ,6,2) AS `MONTH`, SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
WHERE substring(`DATE` ,6,2) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH ROLLING_TOTAL AS
(
SELECT substring(`DATE` ,6,2) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM LAYOFFS_STAGING2
WHERE substring(`DATE` ,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` ,total_off
,SUM(total_off)over(ORDER BY `MONTH`) AS ROLLING_TOTAL
FROM ROLLING_TOTAL;


SELECT company, SUM(TOTAL_LAID_OFF)
FROM LAYOFFS_STAGING2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY COMPANY, YEAR(`DATE`)
ORDER BY 3 DESC;


WITH  Company_year (company, years, total_laid_off) AS
(
SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`DATE`)
), company_year_rank AS
(SELECT *,
dense_rank() OVER (partition by years ORDER BY total_laid_off DESC)AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM COMPANY_YEAR_RANK
WHERE RANKING <= 5;








