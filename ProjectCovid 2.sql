--SELECT TOP (1000) [iso_code]
--      ,[continent]
--      ,[location]
--      ,[date]
--      ,[total_cases]
--      ,[new_cases]
--      ,[new_cases_smoothed]
--      ,[total_deaths]
--      ,[new_deaths]
--      ,[new_deaths_smoothed]
--      ,[total_cases_per_million]
--      ,[new_cases_per_million]
--      ,[new_cases_smoothed_per_million]
--      ,[total_deaths_per_million]
--      ,[new_deaths_per_million]
--      ,[new_deaths_smoothed_per_million]
--      ,[reproduction_rate]
--      ,[icu_patients]
--      ,[icu_patients_per_million]
--      ,[hosp_patients]
--      ,[hosp_patients_per_million]
--      ,[weekly_icu_admissions]
--      ,[weekly_icu_admissions_per_million]
--      ,[weekly_hosp_admissions]
--      ,[weekly_hosp_admissions_per_million]
--      ,[new_tests]
--      ,[total_tests]
--      ,[total_tests_per_thousand]
--      ,[new_tests_per_thousand]
--      ,[new_tests_smoothed]
--      ,[new_tests_smoothed_per_thousand]
--      ,[positive_rate]
--      ,[tests_per_case]
--      ,[tests_units]
--      ,[total_vaccinations]
--      ,[people_vaccinated]
--      ,[people_fully_vaccinated]
--      ,[new_vaccinations]
--      ,[new_vaccinations_smoothed]
--      ,[total_vaccinations_per_hundred]
--      ,[people_vaccinated_per_hundred]
--      ,[people_fully_vaccinated_per_hundred]
--      ,[new_vaccinations_smoothed_per_million]
--      ,[stringency_index]
--      ,[population]
--      ,[population_density]
--      ,[median_age]
--      ,[aged_65_older]
--      ,[aged_70_older]
--      ,[gdp_per_capita]
--      ,[extreme_poverty]
--      ,[cardiovasc_death_rate]
--      ,[diabetes_prevalence]
--      ,[female_smokers]
--      ,[male_smokers]
--      ,[handwashing_facilities]
--      ,[hospital_beds_per_thousand]
--      ,[life_expectancy]
--      ,[human_development_index]
--  FROM [CovidProject].[dbo].[CovidDeaths$]

--SELECT *
--FROM CovidDeaths$
--Order by location, date

--SELECT * 
--FROM CovidVaccinations$

--select location
--from CovidDeaths$


--SELECT location, date, total_cases, new_cases, total_deaths, population
--from CovidDeaths$
--order by location, date


-- „Ã„Ê⁄ «·Ê›Ì«  / „Ã„Ê⁄ «·Õ«·«  
 --‰”»… «Õ „«·Ì… «·Ê›«Â ·« ﬁœ— «··Â ⁄‰œ  ⁄—÷ﬂ ·›«Ì—Ê” ﬂÊ—Ê‰« »«·„„·ﬂ… «·⁄—»Ì… «·”⁄ÊœÌ…

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DEATHPERCENT
from CovidDeaths$
WHERE location LIKE '%saudi%'
order by location, date

-- ‰”»… «·”ﬂ«‰ «·–Ì‰  ⁄—÷Ê ·›«Ì—Ê” ﬂÊ—Ê‰« »«·„„·ﬂ… «·⁄—»Ì… «·”⁄ÊœÌ…

SELECT location, date, population,total_cases, (total_cases/population)*100 as CASES_percent
from CovidDeaths$
WHERE location LIKE '%saudi%'
order by location, date

-- ‰”»… «·„ Ê›Ì‰ —Õ„Â„ «··Â Ã„Ì⁄« »›«Ì—Ê” ﬂÊ—Ê‰« »«·„„·ﬂ… «·⁄—»Ì… «·”⁄ÊœÌ…

SELECT location, date, population, total_deaths, (total_deaths/population)*100 as DeathsPercent
from CovidDeaths$
WHERE location LIKE '%saudi%'
order by date asc


 --  «⁄·Ï «·œÊ· ·œÌÂ« Ê›Ì«  »„—÷ 

 SELECT location, MAX(cast(total_deaths as int)) as Highest_TOTAL_DEATH
 from CovidDeaths$
 where continent IS NOT NULL
 group by  location
 order by Highest_TOTAL_DEATH desc


--‰”»… «·Ê›Ì«  ··«’«»«  ÕÊ· «·⁄«·„

 SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
 SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercent
 from CovidDeaths$
where continent IS NOT NULL
 group by  date
 order by 1,2

 -- „Ã„Ê⁄ «·«’«»«  »ﬂÊ—Ê‰« Ê «·Ê›Ì«  Ê‰”»… «·Ê›«… »«·⁄«·„
 
 SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
 SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercent
 from CovidDeaths$
where continent IS NOT NULL
order by 1,2

-- ‰”»… «·‰«” Ã„Ì⁄« Ê «·‰«” «·„ ·ﬁÌ‰ ··ﬁ«Õ 

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
from CovidDeaths$ Dea
		JOIN CovidVaccinations$ Vac
		ON Dea.location = Vac.location
		and Dea.date = Vac.date
		WHERE Dea.continent IS NOT NULL
		order by 2,3
		 
		 -- ‰”»… «·‰«” Ã„Ì⁄« Ê «·‰«” «·„ ·ﬁÌ‰ ··ﬁ«Õ 

		 SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
		 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (partition  by dea.location order by dea.location,dea.date) as RollimgPeopleVaccinated
from CovidDeaths$ Dea
		JOIN CovidVaccinations$ Vac
		ON Dea.location = Vac.location
		and Dea.date = Vac.date
		WHERE Dea.continent IS NOT NULL
		order by 2,3

--USE CTE 


With PopvsVac (continent, location, date, population, new_vaccinations,RollimgPeopleVaccinated)
as
(
 SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (partition  by dea.location order by dea.location,dea.date) as RollimgPeopleVaccinated
from CovidDeaths$ Dea
JOIN CovidVaccinations$ Vac
ON Dea.location = Vac.location
and Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--Order by 2,3
)
SELECT *, (RollimgPeopleVaccinated/population)*100 as percentVaccinated
from PopvsVac



--TEMP TABLE ÿ«Ê·… „ƒﬁ …


DROP table if exists #percentpopulationvaccinated
CREATE TABLE #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date Datetime,
population numeric,
new_vaccinations numeric,
RollimgPeopleVaccinated numeric,
)

INSERT INTO #percentpopulationvaccinated

 SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (partition  by dea.location order by dea.location,dea.date) as RollimgPeopleVaccinated
from CovidDeaths$ Dea
JOIN CovidVaccinations$ Vac
ON Dea.location = Vac.location
and Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--Order by 2,3

SELECT *, (RollimgPeopleVaccinated/population)*100 as percentVaccinated
from #percentpopulationvaccinated


-- CREATE VIEW

CREATE VIEW percentpopulationvaccinated as
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (partition  by dea.location order by dea.location,dea.date) as RollimgPeopleVaccinated
from CovidDeaths$ Dea
JOIN CovidVaccinations$ Vac
ON Dea.location = Vac.location
and Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL

