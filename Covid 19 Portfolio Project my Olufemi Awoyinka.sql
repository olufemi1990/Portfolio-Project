SELECT *
FROM PortfolioProjectOlufemi..CovidDeaths$
WHERE continent is not null
ORDER BY 3, 4

SELECT * 
FROM PortfolioProjectOlufemi..CovidVaccinations$
ORDER BY 3, 4

--select data that we are using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectOlufemi..CovidDeaths$
ORDER BY 1,2

--lets consider total cases vs total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProjectOlufemi..CovidDeaths$
--WHERE continent like '%Australia%'
ORDER BY 1,2

--lets look at the total cases vs population by percentage

SELECT location, date, population, total_cases, (total_cases/population)*100 AS DeathPercentage
FROM PortfolioProjectOlufemi..CovidDeaths$
WHERE location like '%Australia%'
ORDER BY 1,2

--lets look at country with the highest infection rate as compared to there population

SELECT continent, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS 
PercentagePopulationInfected
FROM PortfolioProjectOlufemi..CovidDeaths$
--WHERE location like '%Australia%'
GROUP BY continent, population
ORDER BY PercentagePopulationInfected DESC



--countries with highest death count by population

SELECT location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProjectOlufemi..CovidDeaths$
--WHERE location like '%Australia%'
GROUP BY location
ORDER BY TotalDeathCount DESC

--lets examine it by continents

SELECT continent, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProjectOlufemi..CovidDeaths$
--HERE location like '%Australia%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


Total Population vs Vaccinations showing Percentage of Population that has recieved at least one Covid Vaccine


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProjectOlufemi..CovidDeaths$ dea
Join PortfolioProjectOlufemi..CovidVaccinations$ vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3 


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectOlufemi..CovidDeaths$ dea
Join PortfolioProjectOlufemi..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 