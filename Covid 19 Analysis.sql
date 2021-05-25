Select location, date, total_cases, new_cases, total_deaths, population 
from dbo.CovidDeaths
order by 1,2

--looking at total cases vs total deaths 
--shows the likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from dbo.CovidDeaths 
where location like '%india%'
order by 1,2

--Looking at total cases vs population

Select location, date, total_cases, population, (total_cases/population)*100 as Percet_Population_infected
from dbo.CovidDeaths 
where location like '%india%'
order by 1,2

--looking at coutries with higest infection rate compared to population

Select location, population, MAX(total_cases) as Highest_infection_count,  MAX((total_cases/population))*100 as Percet_Population_infected
from dbo.CovidDeaths 
--where location like '%india%'
Group by location, population
order by Percet_Population_infected desc


--Showing countries with highest death count by population 

Select location, population, MAX(total_cases) as Highest_infection_count, MAX (total_deaths) as Highest_death_rate, MAX((total_deaths/total_cases))*100 as Percet_Population_deaths
from dbo.CovidDeaths 
--where location like '%india%'
Group by location, population
order by Percet_Population_deaths desc

--


select location, MAX(cast (total_deaths as int))as total_death_count
from dbo.CovidDeaths 
--where location like '%india%'
where continent is not null
Group by location
order by total_death_count desc
