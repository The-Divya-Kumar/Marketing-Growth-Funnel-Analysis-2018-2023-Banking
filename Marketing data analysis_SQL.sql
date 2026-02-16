----CREATE TABLE SCRIPTS ----
-- Table: public.marketing_data_cleaned

-- DROP TABLE IF EXISTS public.marketing_data_cleaned;

CREATE TABLE IF NOT EXISTS public.marketing_data_cleaned
(
    country_group text COLLATE pg_catalog."default",
    signups integer,
    kyc_completed integer,
    first_time_mau integer,
    lapsed_mau integer,
    reactivated_mau integer,
    churned_mau integer,
    month_num integer,
    year integer,
    month text COLLATE pg_catalog."default",
    net_active_mau bigint,
    month_year date
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.marketing_data_cleaned
    OWNER to postgres;

-- Table: public.marketing_data_cleaned_dump - I took the cleaned data from Python and dumped it in this table using pgadmin import. 

-- DROP TABLE IF EXISTS public.marketing_data_cleaned_dump;

CREATE TABLE IF NOT EXISTS public.marketing_data_cleaned_dump
(
    month text COLLATE pg_catalog."default",
    country_group text COLLATE pg_catalog."default",
    signups double precision,
    kyc_completed double precision,
    first_time_mau double precision,
    lapsed_mau double precision,
    reactivated_mau double precision,
    churned_mau double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.marketing_data_cleaned_dump
    OWNER to postgres;

---- I inserted the data from the dumped table into this after adding some new calculated columns and splitting some columns to usable types


insert into marketing_data_cleaned (
  country_group, 
  signups, 
  kyc_completed, 
  first_time_mau, 
  lapsed_mau, 
  reactivated_mau, 
  churned_mau, 
  month_num,
  year,
  month,
  net_active_mau,
  month_year
)
SELECT 
  country_group, 
  signups, 
  kyc_completed, 
  first_time_mau, 
  lapsed_mau, 
  reactivated_mau, 
  churned_mau, 
  EXTRACT(MONTH FROM TO_DATE(month, 'YYYY-MM-DD')) AS month_num,
  EXTRACT(YEAR FROM TO_DATE(month, 'YYYY-MM-DD')) AS year,
  TO_CHAR(TO_DATE(month, 'YYYY-MM-DD'), 'MON') AS month,
  COALESCE(first_time_mau, 0) +
    COALESCE(reactivated_mau, 0) -
    COALESCE(lapsed_mau, 0) as net_active_mau,
	TO_DATE(month, 'YYYY-MM-DD')
FROM marketing_data_cleaned_dump;

SELECT * 
FROM marketing_data_cleaned
WHERE 
  (country_group = 'ITA' AND month_year < '2023-01-01')
  OR
  (country_group != 'ITA' AND month_year < '2024-01-01');

---- Below are the queries which can be used to generate the tables in the excel sheet----
---- SUMMARY OF SIGNUPS -----

select country_group, year, sum(signups) 
from marketing_data_cleaned 
group by country_group, year
order by country_group, year;


---- Attract and Acquire ----

select country_group, year, sum(first_time_mau)/NULLIF(SUM(signups), 0)::FLOAT as signup_to_ftu_conversion,
sum(kyc_completed)/NULLIF(SUM(signups), 0)::FLOAT as kyc_conversion_rate,
sum(first_time_mau)/NULLIF(SUM(kyc_completed), 0)::FLOAT as ftu_conversion_rate
from marketing_data_cleaned
group by country_group, year
order by country_group, year;

---- Engagement and Retention ----


select country_group, year, sum(reactivated_mau)/NULLIF(SUM(lapsed_mau), 0)::FLOAT as signup_to_ftu_conversion,
sum(churned_mau)
from marketing_data_cleaned
group by country_group, year
order by country_group, year;


---- Active user base ----

with net_active_data as 
(select country_group, year, sum(reactivated_mau) + sum(first_time_mau) - sum(lapsed_mau) as net_active_mau
from marketing_data_cleaned
group by country_group, year
order by country_group, year)
select *, coalesce(net_active_mau - lag(net_active_mau) over (partition by country_group order by country_group, year),0) as delta_net_active_mau
from net_active_data
order by country_group, year;
