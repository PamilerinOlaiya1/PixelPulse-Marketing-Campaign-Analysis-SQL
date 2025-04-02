-- I WANT TO CHECK FOR DUPLICATE --
SELECT *, COUNT(*) FROM [Marketing Data]
GROUP BY Campaign,Date,City_Location,Channel,Device,Ad,Impressions,CTR,Clicks,Daily_Average_CPC,Spend_GBP,Conversions,Total_conversion_value_GBP,Likes_Reactions,Shares,Comments,Latitude,Longitude
HAVING COUNT(*) > 1;
-- No Duplicate Detected--

--To remove the '%' in the CTR column  
update [Marketing Data]
set CTR= replace(CTR,'%',' ');

--To now convert the values to decimal 
update [Marketing Data]
set CTR= cast(CTR as decimal(16,1))/100;

--To change the datatype from nvarchar to decimal
alter table [marketing data]
alter column CTR decimal (16,3);

 ----1A   Which campaign generated the highest number of impressions,clicks and conversions?
select campaign,sum(impressions) as impressions, sum(clicks) as clicks,sum(conversions) as conversions
from [Marketing Data]
group by Campaign
order by impressions desc;


Select *
from [Marketing Data]


--Coverting Daily_Average_CPC 
update [Marketing Data]
set Daily_Average_CPC= cast(Daily_Average_CPC as decimal(18,2));

----1B  What is the average cost per click(CPC) and click-through rate (CTR) for each campaign--
SELECT Campaign, 
SUM(Spend_GBP) / SUM(clicks) as CPC, 
cast(AVG(CTR) as decimal(16,4)) AS AVERAGE_CTR, 
cast(avg(Daily_Average_CPC) as decimal(16,4)) AS AVERAGE_CPC
FROM [Marketing Data]
GROUP BY Campaign;

 ---2A which channel has the highest ROI--
 SELECT Campaign, 
 (SUM(Total_conversion_value_GBP) - SUM(Spend_GBP)) / SUM(Spend_GBP) as ROI
FROM [Marketing Data]
GROUP BY Campaign;

---2B How do impressions, clicks, and conversions vary across different  channels?
SELECT Channel,
SUM(Impressions) as Impressions, 
SUM(Clicks) as Clicks, 
SUM(Conversions) as Conversions
FROM [Marketing Data]
GROUP BY Channel;

--3A Which cities have the highest engagement rates (likes, shares, comments)?
SELECT City_Location,
SUM(Likes_Reactions) AS Likes,
SUM(Shares) AS Shares,SUM(Comments) AS Comments,
(SUM(Likes_Reactions)+SUM(Shares) +SUM(Comments)) as engagement
FROM [Marketing Data]
GROUP BY City_Location 
ORDER BY Likes DESC;

--3B What is the conversion rate by city?
SELECT City_Location,
CAST(SUM(Conversions) AS decimal(10,3)) /SUM(CLICKS) * 100 AS Conversion_Rate
FROM [Marketing Data]
GROUP BY City_Location;

--4A How do ad performances compare across different devices (mobile, desktop, tablet)?
SELECT Device,
Ad,
SUM(Likes_Reactions) AS Likes,
SUM(Shares) AS Shares,
SUM(Comments) AS Comments
FROM [Marketing Data]
GROUP BY Device,Ad
ORDER BY Likes DESC;

--4B Which device type generates the highest conversion rates?
SELECT  Device, CAST(SUM(Conversions) AS decimal(10,3)) /SUM(CLICKS) * 100 AS Conversion_Rate
FROM [Marketing Data]
GROUP BY Device;


---5A Which specific ads are performing best in terms of engagement and conversions?
SELECT Ad,
SUM(Likes_Reactions) AS Likes,
SUM(Shares) AS Shares,SUM(Comments) AS Comments,
(SUM(Likes_Reactions)+SUM(Shares) +SUM(Comments)) as engagement,
SUM(Conversions) AS Conversions
FROM [Marketing Data]
GROUP BY Ad
ORDER BY Likes DESC;

--5B What are the common characteristics of high-performing ads?
SELECT Ad, SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments, SUM(Conversions) AS Conversions
FROM [Marketing Data]
GROUP BY Ad
HAVING Ad = 'Discount'
ORDER BY Likes DESC;

SELECT Ad, Likes_Reactions AS Likes, Shares AS Shares, Comments AS Comments, Conversions AS Conversions
FROM [Marketing Data]
WHERE Ad = 'Discount'
ORDER BY Likes DESC;

--6A What is the ROI for each campaign, and how does it compare across different channels and devices?
SELECT Campaign, Channel, Device, (SUM(Total_conversion_value_GBP) - SUM(Spend_GBP)) / SUM(Spend_GBP) as ROI
FROM [Marketing Data]
GROUP BY Campaign,Channel,Device
ORDER BY ROI DESC;

--6B How does spend correlate with conversion value across different campaigns?
SELECT Campaign, SUM(Spend_GBP) AS Spend_GBP, SUM(Total_conversion_value_GBP) AS Total_conversion_value_GBP
FROM [Marketing Data]
GROUP BY Campaign
ORDER BY campaign;

--7A Are there any noticeable trends or seasonal effects in ad performance over time? 
SELECT DATEPART(MONTH, DATE) AS MONTH, DATENAME(MONTH, DATE) AS MONTH_NAME, SUM(Spend_GBP) AS Spend_GBP, SUM(Total_conversion_value_GBP) AS Total_conversion_value_GBP, SUM(Conversions) AS CONVERSIONS
FROM [Marketing Data]
GROUP BY DATEPART(MONTH, DATE), DATENAME(MONTH, DATE) 
ORDER BY MONTH;
