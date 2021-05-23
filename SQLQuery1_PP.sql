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

--lets break things down by continent 

--showing the cotinent with the highest death counts 


select continent, MAX(cast(Total_Deaths as int)) as Total_Death_count                                                  
from dbo.CovidDeaths 
--where location like '%india%'
where continent is not null
Group by continent
order by total_death_count desc



--Global numbers


Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from dbo.CovidDeaths 
--where location like '%india%'
where continent is not null 
group by date
order by 1,2 


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from dbo.CovidDeaths 
--where location like '%india%'
where continent is not null 
--group by date
order by 1,2 


 

-- Joining 2 tables


 Select * 
 from dbo.CovidDeaths dea
 join dbo.CovidVaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date


-- total population vs vaccination


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
 from dbo.CovidDeaths dea
 join dbo.CovidVaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null 
order by 2,3 


--Using CTE 

With PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
 from dbo.CovidDeaths dea
 join dbo.CovidVaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null 
--order by 2,3 
)
select *, (rolling_people_vaccinated/population)*100 as percentpopulationvaccinated
from PopvsVac



--Temp Table


--Drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent NVARCHAR(255),
location NVARCHAR(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
 from dbo.CovidDeaths dea
 join dbo.CovidVaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null 
--order by 2,3 

select *, (rollingpeoplevaccinated/population)*100 as percentpopulationvaccinated
from #percentpopulationvaccinated



--Creating views to store data for later visulaisations 

Create view percentpopulationvaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
 from dbo.CovidDeaths dea
 join dbo.CovidVaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null 
--order by 2,3 





---QUERIES USED FOR TABLEAU PROJECT




-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.CovidDeaths
--Where location like '%India%'
where continent is not null 
--Group By date
order by 1,2


-- 2. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From dbo.CovidDeaths
--Where location like '%India%'
Where continent is null 
and location not in ('World', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.CovidDeaths
--Where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%india%'
Group by Location, Population, date
order by PercentPopulationInfected desc







	
     






