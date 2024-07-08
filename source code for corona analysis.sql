
-- Q1. Write a code to check NULL values
SELECT *  FROM [coviddb].[dbo].['Corona Virus Dataset$']
          where [Country/Region] is null
               or [Latitude] is null
               or [Longitude] is null
               or [Date] is null
               or [Confirmed] is null
               or [Deaths] is null
               or [Recovered] is null
--Q2. If NULL values are present, update them with zeros for all columns. 
-- NO null values found to replace 
-- Q3. check total number of rows
SELECT COUNT (*) AS TOTAL_NUM_OF_ROWS FROM [coviddb].[dbo].['Corona Virus Dataset$']
-- Q4. Check what is start_date and end_date
SELECT MIN(Date) as start_date , MAX(Date) as end_date from [coviddb].[dbo].['Corona Virus Dataset$']
-- Q5. Number of month present in dataset
SELECT 
    COUNT(DISTINCT FORMAT(Date, 'yyyy-MM')) AS NumberOfMonths 
FROM  [coviddb].[dbo].['Corona Virus Dataset$']
-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    FORMAT(Date, 'yyyy-MM') AS MonthYear, 
    AVG(Confirmed) AS AvgConfirmed, 
    AVG(Deaths) AS AvgDeaths, 
    AVG(Recovered) AS AvgRecovered
FROM [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY FORMAT(Date, 'yyyy-MM');

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
WITH MonthlyData AS (
    SELECT 
        FORMAT(Date, 'yyyy-MM') AS MonthYear, 
        Confirmed, 
        Deaths, 
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM'), Confirmed ORDER BY COUNT(*) DESC) AS rn1,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM'), Deaths ORDER BY COUNT(*) DESC) AS rn2,
        ROW_NUMBER() OVER (PARTITION BY FORMAT(Date, 'yyyy-MM'), Recovered ORDER BY COUNT(*) DESC) AS rn3
    FROM [coviddb].[dbo].['Corona Virus Dataset$']
    GROUP BY FORMAT(Date, 'yyyy-MM'), Confirmed, Deaths, Recovered
)
SELECT 
    MonthYear, 
    Confirmed AS MostFrequentConfirmed, 
    Deaths AS MostFrequentDeaths, 
    Recovered AS MostFrequentRecovered
FROM MonthlyData
WHERE rn1 = 1 AND rn2 = 1 AND rn3 = 1;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year, 
    MIN(Confirmed) AS Min_Confirmed, 
    MIN(Deaths) AS Min_Deaths, 
    MIN(Recovered) AS Min_Recovered
FROM [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY YEAR(Date);
-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year, 
    MAX(Confirmed) AS MAX_Confirmed, 
    MAX(Deaths) AS MAX_Deaths, 
    MAX(Recovered) AS MAX_Recovered
FROM [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY YEAR(Date);
-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    FORMAT(Date, 'yyyy-MM') AS Month_Year, 
    SUM(Confirmed) AS Total_Confirmed, 
    SUM(Deaths) AS Total_Deaths, 
    SUM(Recovered) AS Total_Recovered
FROM [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY FORMAT(Date, 'yyyy-MM');

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Confirmed) AS TotalConfirmed, 
    AVG(Confirmed) AS AvgConfirmed, 
    VAR(Confirmed) AS VarianceConfirmed, 
    STDEV(Confirmed) AS StdevConfirmed
FROM [coviddb].[dbo].['Corona Virus Dataset$']

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    FORMAT(Date, 'yyyy-MM') AS MonthYear, 
    SUM(Deaths) AS TotalDeaths, 
    AVG(Deaths) AS AvgDeaths, 
    VAR(Deaths) AS VarianceDeaths, 
    STDEV(Deaths) AS StdevDeaths
FROM [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY FORMAT(Date, 'yyyy-MM');

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Recovered) AS TotalRecovered, 
    AVG(Recovered) AS AvgRecovered, 
    VAR(Recovered) AS VarianceRecovered, 
    STDEV(Recovered) AS StdevRecovered
FROM [coviddb].[dbo].['Corona Virus Dataset$']

-- Q14. Find Country having highest number of the Confirmed case
SELECT TOP 1 [Country/Region], MAX(Confirmed) AS MaxConfirmed
FROM  [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY [Country/Region]
ORDER BY MaxConfirmed DESC;

-- Q15. Find Country having lowest number of the death case
SELECT TOP 1 [Country/Region], MIN(Deaths) AS MinDeaths
FROM  [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY [Country/Region]
ORDER BY MinDeaths;

-- Q16. Find top 5 countries having highest recovered case
SELECT TOP 5 [Country/Region], MAX(Recovered) AS MaxRecovered
FROM  [coviddb].[dbo].['Corona Virus Dataset$']
GROUP BY [Country/Region]
ORDER BY MaxRecovered DESC;
