-- Средний ROI и средний коэффициент конверсии по целям рекламных кампаний
SELECT 
    Campaign_Goal,
    AVG(ROI) AS Avg_ROI,
    AVG(Conversion_Rate) AS Avg_Conversion_Rate
FROM Fact_Campaign
GROUP BY Campaign_Goal
ORDER BY Avg_ROI DESC;

-- Суммарные показы и клики по каждому рекламному каналу
SELECT 
    ch.Channel_Name,
    SUM(f.Impressions) AS Total_Impressions,
    SUM(f.Clicks) AS Total_Clicks
FROM Fact_Campaign f
JOIN Dim_Channel ch ON f.Channel_ID = ch.Channel_ID
GROUP BY ch.Channel_Name
ORDER BY Total_Impressions DESC;

-- Средний ROI по городам и языкам кампаний

SELECT 
    g.City,
    g.Language,
    AVG(f.ROI) AS Avg_ROI
FROM Fact_Campaign f
JOIN Dim_Geography g ON f.Geography_ID = g.Geography_ID
GROUP BY g.City, g.Language
ORDER BY Avg_ROI DESC;

-- Динамика среднего ROI по месяцам

SELECT 
    c.Year,
    c.Month,
    AVG(f.ROI) AS Avg_ROI
FROM Fact_Campaign f
JOIN Dim_Calendar c ON f.Date_ID = c.Date_ID
GROUP BY c.Year, c.Month
ORDER BY c.Year, c.Month;

-- Ранжирование каналов по среднему ROI внутри каждого типа канала

SELECT 
    ch.Channel_Type,
    ch.Channel_Name,
    AVG(f.ROI) AS Avg_ROI,
    RANK() OVER (
        PARTITION BY ch.Channel_Type 
        ORDER BY AVG(f.ROI) DESC
    ) AS Channel_Rank
FROM Fact_Campaign f
JOIN Dim_Channel ch ON f.Channel_ID = ch.Channel_ID
GROUP BY ch.Channel_Type, ch.Channel_Name;

-- Количество кампаний и средний ROI по ответственным сотрудникам

SELECT 
    r.Employee_Name,
    r.Position,
    COUNT(DISTINCT f.Campaign_ID) AS Campaign_Count,
    AVG(f.ROI) AS Avg_ROI
FROM Fact_Campaign f
JOIN Bridge_Campaign_Responsible b 
    ON f.Campaign_ID = b.Campaign_ID
JOIN Dim_Responsible r 
    ON b.Responsible_ID = r.Responsible_ID
GROUP BY r.Employee_Name, r.Position
ORDER BY Avg_ROI DESC;

-- Топ-5 индустрий по суммарному ROI и кликам

SELECT TOP 5
    c.Industry,
    SUM(f.Clicks) AS Total_Clicks,
    AVG(f.ROI) AS Avg_ROI
FROM Fact_Campaign f
JOIN Dim_Company c ON f.Company_ID = c.Company_ID
GROUP BY c.Industry
ORDER BY Avg_ROI DESC;