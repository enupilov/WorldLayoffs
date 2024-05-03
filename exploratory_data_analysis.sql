-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Maximum Quantity of Laid Off People by 1 Day
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Maximum Percent of Laid Off People in Terms of All Employees
SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Companies with the Biggest Total Laid Offs
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies with the Biggest Raised Funds
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the Most Layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Date Range of Layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Industries with the Most Layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Countries with the Most Layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Layoffs by Year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Layoffs by Stage of the Company
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- Total Layoffs and Rolling Number of Layoffs by Month
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) As total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

-- Layoffs in Companies by Year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 Companies with the Most Layoffs by Year
WITH Company_Year (company, country, years, total_laid_off) AS
(
SELECT company, country, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, country, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;

-- Top 5 Industries with the Most Layoffs by Year
WITH Industry_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Industry_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Industry_Year_Rank
WHERE ranking <= 5;

-- Top 3 Countries with the Most Layoffs by Year
WITH Country_Year (country, years, total_laid_off) AS
(
SELECT country, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, YEAR(`date`)
), Country_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Country_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Country_Year_Rank
WHERE ranking <= 3;

-- Top 5 Industries in the United States with the Most Layoffs by Year
WITH Industry_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE country = 'United States'
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Industry_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Industry_Year_Rank
WHERE ranking <= 5;

-- Top 5 Companies in the United States with the Most Layoffs by Year
WITH Company_Year (company, industry, years, total_laid_off) AS
(
SELECT company, industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE country = 'United States'
GROUP BY company, industry, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;