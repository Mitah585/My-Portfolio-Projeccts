-- Data Cleaning


select *
from layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any uncessesary columns

-- Create a copy of the original data

create table layoffs_staging
like layoffs; -- copies the columns from the original table

select *
from layoffs_staging; -- currently empty

insert layoffs_staging -- copies the data from the original table
select *
from layoffs;

-- Remove duplicates
-- To remove the duplicates in this data, we need to work with the staging table
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date` ) as row_num
from layoffs_staging;
-- Since we do not have a unique identifier of the rows, we use the row_num function to assigns a unique, sequential number to rows so that we can rank or number rows without needing an explicitly defined unique identifier. 
with duplicate_cte as
(select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions ) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num >1;

select *
from layoffs_staging
where company = 'Yahoo';


with duplicate_cte as
(select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions ) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num >1;

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

Select *
from layoffs_staging2;

Insert into layoffs_staging2
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions ) as row_num
from layoffs_staging
;

Delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num > 1;

-- Standardizing data

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);


select *
from layoffs_staging2
where industry like 'Crypto%'
;

update layoffs_staging2
SET industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct industry
from layoffs_staging2
;

Select distinct country
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like 'United States%'
Order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%'
;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoffs_staging2
;

alter table layoffs_staging2
modify column `date` date; -- changes the column data type, always do this in the copy data

select *
from layoffs_staging2;

-- Null and blank values

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
 from layoffs_staging2
 where industry is null
 or industry = '';
 
 select *
 from layoffs_staging2	
 where company like 'Airbnb';
 
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
	and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null;

select *
from layoffs_staging2;


-- Remove unnecessary columns or rows

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

Delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
;

alter table layoffs_staging2
drop column row_num;