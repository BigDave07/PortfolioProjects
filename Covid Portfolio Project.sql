
Select *
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--Order by 3,4

Select location, date, total_cases,new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths$
Where continent is not null
Order by 1,2


Total Case vs Total Deaths (Death Percentage) 

--Select continent, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
--From PortfolioProject..CovidDeaths$
----Where location like '%Nigeria%'
--Where continent is not null
--Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%Nigeria%'
and continent is not null
Order by 1,2




-- Total Cases vs Population
-- Shows what percentage of the Population got Covid

--Select continent, date, total_cases, population, (total_cases/population)* 100 as populationpercentage
--From PortfolioProject..CovidDeaths$
----Where location like '%Nigeria%'
--Where continent is not null
--Order by 1,2


Select location, date, total_cases, population, (total_cases/population)* 100 as populationpercentage
From PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
Order by 1,2


-- Countries with the Highest Infection Rate compared to Population	

--Select Continent, population, MAX(total_cases) as HighestInfectedPopulation,  Max((total_cases/population))* 100 as populationpercentage 
--From PortfolioProject..CovidDeaths$
--Group by Continent, Population
----Where location like '%Nigeria%'
--Order by Populationpercentage desc


Select location, population, MAX(total_cases) as HighestInfectedPopulation,  Max((total_cases/population))* 100 as populationpercentage 
From PortfolioProject..CovidDeaths$
Group by Location, Population
--Where location like '%Nigeria%'
Order by Populationpercentage desc


--Countries With the Highest Death Count Per Population

--Select continent, MAX(cast(total_deaths as int)) as TotalDeaths
--From PortfolioProject..CovidDeaths$
--Where continent is not null
--Group by continent
------Where location like '%Nigeria%'
--Order by TotalDeaths desc


Select location, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by Location
--Where location like '%Nigeria%'
Order by TotalDeaths desc



-- LETS BREAK THINGS DOWN BY CONTINENT


-- Showing the continent with the highest death count

Select continent, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
--Where location like '%Nigeria%'
Order by TotalDeaths desc



-- GLOBAL DEATHS

Select date, Sum(new_cases) as TotalCases, Sum(cast (new_deaths as int)) as TotalDeaths, Sum(cast (new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by date
order by 1,2


Select Sum(new_cases) as TotalCases, Sum(cast (new_deaths as int)) as TotalDeaths, Sum(cast (new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
--Group by date
order by 1,2



-- Looking at Total Population Vs Vaccinations


Select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$  dea
--(RollingPeopleVaccinated/population)*100
  Join PortfolioProject..CovidVaccinations$  vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
order by 2,3

USING CTE

With PopvsVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$  dea
  Join PortfolioProject..CovidVaccinations$  vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP TABLES

Drop Table if exists #PercentagePeopleVaccinated
Create Table #PercentagePeopleVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentagePeopleVaccinated
Select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$  dea
  Join PortfolioProject..CovidVaccinations$  vac
  on dea.location = vac.location
  and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentagePeopleVaccinated



-- Creating View to store data for later visualizations

Create View DeathPecentage as 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
--Order by 1,2

Create View PercentageofAffedtedPopulation as
Select location, date, total_cases, population, (total_cases/population)* 100 as populationpercentage
From PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
--Order by 1,2

Create View PercentageofHighestAffectedPopulation as
Select location, population, MAX(total_cases) as HighestInfectedPopulation,  Max((total_cases/population))* 100 as populationpercentage 
From PortfolioProject..CovidDeaths$
Group by Location, Population
--Where location like '%Nigeria%'
--Order by Populationpercentage desc

Create View TotalDeaths as
Select location, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by Location
--Where location like '%Nigeria%'
--Order by TotalDeaths desc

Create View ContinentsTotalDeath as 
Select continent, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
--Where location like '%Nigeria%'
--Order by TotalDeaths desc

Create View GlobalDeathPercentagebyDate as
Select date, Sum(new_cases) as TotalCases, Sum(cast (new_deaths as int)) as TotalDeaths, Sum(cast (new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by date
--order by 1,2

Create View GlobalDeath as
Select Sum(new_cases) as TotalCases, Sum(cast (new_deaths as int)) as TotalDeaths, Sum(cast (new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
--Group by date
--order by 1,2


Create View PercentageofPopulationVaccinatedbyDate as
Select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$  dea
--(RollingPeopleVaccinated/population)*100
  Join PortfolioProject..CovidVaccinations$  vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


