--Pulling the table details ordering by location 

select * from covid_deaths order by 3

--Finding out the population of India and Canada 

select distinct population as Population_India 
from covid_deaths 
where location = 'India'


select distinct population as Population_Canada 
from covid_deaths 
where location = 'Canada'

--Finding the total cases in India  

select location, date,total_cases 
from covid_deaths
where location ='India'
order by total_cases desc

--Finding the total cases in Canada  

select location, date,total_cases 
from covid_deaths
where location ='Canada'
order by total_cases desc



--Finding the maximum number of cases in India and Canada 

select max(total_cases)as maxcases
from covid_deaths 
where location = 'India'


select max(total_cases)as maxcases 
from covid_deaths 
where location = 'Canada'

--Finding out the maximum number of deaths occured in India and Canada

select max(total_deaths) as totaldeaths_India 
from covid_deaths 
where location ='India'

select max(total_deaths) as totaldeaths_Canada 
from covid_deaths 
where location = 'Canada'


--Changing the datatype of columns from varchar to float to perform division operation 

alter table covid_deaths
alter column total_deaths float


alter table covid_deaths
alter column total_cases float


--Finding the death percentage of India and Canada 

select location,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from covid_deaths 
where location like'%Indi%'


select location,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from covid_deaths 
where location like'%Can%'


--Finding out the date where maximum number of deaths were reported in India 

select location,date ,total_deaths as highest_deaths_reported
from covid_deaths 
where total_deaths =(select max(total_deaths) from covid_deaths where location='India')

--Finding out the date where maximum number of deaths were reported in Canada 

select location,date ,total_deaths as highest_deaths_reported
from covid_deaths 
where total_deaths =(select max(total_deaths) from covid_deaths where location like '%Can%')
 
 
 --Looking at the vaccination table details 

 select * from Nir_PortfolioProject.dbo.covid_vaccnations
 
 
 --Looking at the total population vs vaccinations (using joins)

 select d.population,d.location,d.date,vac.new_vaccinations
 from covid_deaths d
 join Nir_PortfolioProject.dbo.covid_vaccnations vac 
 on d.location=vac.location
 and d.date=vac.date 
 where d.continent is not null
 order by 2



