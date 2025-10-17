-- Creating database ENERGY

create database ENERGY;

-- use ENERGY database

use ENERGY;

-- 1. country table
create table country (
    country varchar(100) primary key,
    c_id varchar(10)
);

select * from country;

select count(*) as total_rows
from country;

-- 2. consumption table
create table consumption (
    country varchar(100),
    energy varchar(50),
    year int not null,
    consumption int,
    foreign key (country) references country(country)
);

select * from consumption;

select count(*) as total_rows
from consumption;


-- 3. production table
create table production (
    country varchar(100),
    energy varchar(50),
    year int not null,
    production int,
    foreign key (country) references country(country)
);

select * from production;

select count(*) as total_rows
from production;


-- 4. emission table
create table emission (
    country varchar(100),
    energy_type varchar(50),
    year int not null,
    emission int,
    per_capita_emission double,
    foreign key (country) references country(country)
);

select count(*) as Total_emission_rows
from emission;


-- 5. gdp_ppp table
create table gdp_ppp (
    country varchar(100),
    year int not null,
    value double,
    foreign key (country) references country(country)
);

select count(*) as total_rows
from gdp_ppp;

-- 6. population table
create table population (
    country varchar(100),
    year int not null,
    value double,
    foreign key (country) references country(country)
);

select count(*) as total_population
from population;

select * from country;
select * from consumption;
select * from production;
select * from emission;
select * from gdp_ppp;
select * from population;

select count(*) as emission_t
from emission;


------------------------- ## Data Analysis Quetions ------------------------------

-- General & Comparative Analysis

## Q1. What is the total emission per country for the most recent year available?

select country, sum(emission) as Total_emission
from emission
where year = (select max(year) from emission)
group by country
order by Total_emission desc;

## Q2. What are the top 5 countries by GDP in the most recent year?

select country, value as gdp
from gdp_ppp
where year = (select max(year) from gdp_ppp)
order by value desc
limit 5; 

-- Compare energy production and consumption by country and year.

## Q3. Which energy types contribute most to emissions across all countries?

select energy_type,country, sum(emission) as total_emission
from emission
group by energy_type ,country
order by total_emission desc;

-- Trend Analysis Over Time
## Q4. How have global emissions changed year over year?

select year,
sum(emission) as Total_emission
from emission
group by year
order by year;


## Q5. What is the trend in GDP for each country over the given years?

select country, year, value
from gdp_ppp
order by value desc, year;
	

## Q6. How has population growth affected total emissions in each country?

select p.country, p.year, p.value ,sum(emission) as population_count
from emission as e 
join population as p
on e.country = p.country and p.year = e.year
group by p.country,p.year ,p.value
order by country,year;

-- Q7. Has energy consumption increased or decreased over the years for major economies?

select country, year, SUM(consumption) AS total_consumption
from consumption
group by country, year
order by year, total_consumption DESC
limit 10;

-- Q8. What is the average yearly change in emissions per capita for each country?

select country,year, round(avg(per_capita_emission),6) as avg_per_capita_emission
from emission
group by country,year;

-- Q10. What is the energy consumption per capita for each country over the last decade?

select e.country, e.year, round(sum(e.emission)/g.value,5) as emission_to_gdp
from emission e join gdp_ppp g on e.country = g.country
and e.year = g.year
group by country, year, g.value
order by country,year;


-- Q12. Which countries have the highest energy consumption relative to GDP?

select c.country, round(sum(c.consumption)/sum(g.value),5) as consumption_relative_to_GDP
from consumption c join gdp_ppp g on c.country = g.country
and c.country = g.country
group by country
order by consumption_relative_to_GDP desc;



--  Global Comparisons

-- Q14. What are the top 10 countries by population and how do their emissions compare?

select p.country, sum(p.value) as population, round(sum(e.emission),4) as emission
from population p join emission e on p.country = e.country
and e.year = p.year
group by p.country
order by population desc
limit 10;


-- Q16. What is the global share (%) of emissions by country?

select country, sum(emission)*100/(select sum(emission)
from emission) as share_percent
from emission
group by country
order by share_percent desc;

