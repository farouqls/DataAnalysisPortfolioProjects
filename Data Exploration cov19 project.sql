-- Covid 19 Data Exploration
-- Skills used: Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting Data Types

-- Select Data that we are going to be starting with
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths,
(CAST(total_deaths AS SIGNED)/CAST(total_cases AS SIGNED))*100 as DeathPercentage
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT location, date, population, total_cases,
(CAST(total_cases AS SIGNED)/CAST(population AS SIGNED))*100 as PercentPopulationInfected
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to Population
SELECT location, population,
MAX(CAST(total_cases AS SIGNED)) as HighestInfectionCount,
MAX((CAST(total_cases AS SIGNED)/CAST(population AS SIGNED)))*100 as PercentPopulationInfected
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per Population
SELECT location,
MAX(CAST(total_deaths AS SIGNED)) as TotalDeathCount
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Breaking things down by Continent
-- Showing continents with the highest death count per population
SELECT continent,
MAX(CAST(total_deaths AS SIGNED)) as TotalDeathCount
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers
SELECT
SUM(CAST(new_cases AS SIGNED)) as total_cases,
SUM(CAST(new_deaths AS SIGNED)) as total_deaths,
SUM(CAST(new_deaths AS SIGNED))/SUM(CAST(new_cases AS SIGNED))*100 as DeathPercentage
FROM portfolioProject.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Joining Deaths and Vaccinations tables to track rolling cumulative vaccinations per country over time
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM portfolioProject.coviddeaths dea
JOIN portfolioProject.covidvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- Using CTE to calculate percentage of population vaccinated over time
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
    FROM portfolioProject.coviddeaths dea
    JOIN portfolioProject.covidvaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
FROM PopvsVac;

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TEMPORARY TABLE PercentPopulationVaccinated
(
Continent VARCHAR(255),
Location VARCHAR(255),
Date TEXT,
Population TEXT,
New_vaccinations TEXT,
RollingPeopleVaccinated TEXT
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(NULLIF(vac.new_vaccinations, '')AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM portfolioProject.coviddeaths dea
JOIN portfolioProject.covidvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

SELECT *, (CAST(RollingPeopleVaccinated AS SIGNED)/CAST(Population AS SIGNED))*100 as PercentVaccinated
FROM PercentPopulationVaccinated;

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinatedView AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM portfolioProject.coviddeaths dea
JOIN portfolioProject.covidvaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;