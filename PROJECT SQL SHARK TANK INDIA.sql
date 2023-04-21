#PROJECT ON SHARK TANK INDIA

/*About The Project - The project for Shark Tank India involves analyzing the dataset of all the pitches 
made on the show, with the aim of identifying patterns and trends that can provide insights into the factors
that lead to successful pitches. The dataset includes information on the brand name, idea, pitch number,
episode number, pitcher ask amount, ask equity, ask valuation, deal amount, 
deal equity, deal valuation, and the sharks involved in each pitch.*/
------------------------------------------------------------------------------------------------------------------------------

#Database Creation and Using the database
Create Database SharkTankIndia;
Use SharkTankIndia;

------------------------------------------------------------------------------------------------------------------------------

#INSERTING THE DATASET FROM NAVIGATOR
#CHECKING HOW IT LOOKS 
select * from Shark_Tank_India_DataSet; #NOTE THE AMOUNT VALUES ARE IN LAKHS.
-------------------------------------------------------------------------------------------------------------------------------------------
#NOW LETS NORMALIZE THE DATA INTO 3 TABLES : EPISODE, DEALS, SHARKSDEAL 
-- Normalization helps to eliminate data redundancy by dividing the data into smaller
-----------------------------------------------------------------------------------------------------------------------------------
#Creating Table 1 - Episode
Create Table Episode
(Episode_number INT,
Pitch_Number INT PRIMARY KEY,
Brand_Name VARCHAR(60),
Idea VARCHAR(100),
Pitcher_Ask_Amount INT,
Ask_Equity INT,
Ask_Valuation INT
);
--------------------------------------------------------------------------------------------------------------------------
#INSERTING THE VALUES INTO THE EPISODE TABLE FROM THE WHOLE SHARK TANK INDIA DATASET

INSERT INTO Episode (Episode_Number, Pitch_Number, Brand_Name, Idea, Pitcher_Ask_Amount, Ask_Equity, Ask_Valuation)
SELECT DISTINCT Episode_Number, Pitch_Number, Brand_Name, Idea, Pitcher_Ask_Amount, Ask_Equity, Ask_Valuation
FROM Shark_Tank_India_DataSet;
------------------------------------------------------------------------------------------------------------------------------------
#Creating Table 2 - Deal
Create Table Deal
(Pitch_Number Int,
Deal_Amount INT,
Deal_Equity INT,
Deal_Valuation INT,
FOREIGN KEY (Pitch_Number) REFERENCES Episode(Pitch_Number)
);
-------------------------------------------------------------------------------------------------------------------------------------
#INSERTING THE VALUES INTO THE DEAL TABLE FROM THE WHOLE SHARK TANK INDIA DATASET

INSERT INTO Deal (Pitch_Number, Deal_Amount, Deal_Equity, Deal_Valuation)
SELECT DISTINCT Pitch_Number, Deal_Amount, Deal_Equity, Deal_Valuation
FROM Shark_Tank_India_DataSet;
-----------------------------------------------------------------------------------------------------------------------------------------------------
#Creating Table 3 - SharksDeal
Create Table SharksDeal
(Pitch_Number Int,
Ashneer_Deal ENUM('Yes', 'No'),
Anupam_Deal ENUM('Yes', 'No'),
Aman_Deal ENUM('Yes', 'No'),
Namita_Deal ENUM('Yes', 'No'),
Vineeta_Deal ENUM('Yes', 'No'),
Peyush_Deal ENUM('Yes', 'No'),
Ghazal_Deal ENUM('Yes', 'No'),
Total_Sharks_Involved INT NOT NULL,
FOREIGN KEY (Pitch_Number) REFERENCES Episode(Pitch_Number)
);
-----------------------------------------------------------------------------------------------------------------------------------------------------
#INSERTING THE VALUES INTO THE SHARKSDEAL TABLE FROM THE WHOLE SHARK TANK INDIA DATASET

INSERT INTO SharksDeal (Pitch_Number, Ashneer_Deal, Anupam_Deal, Aman_Deal, Namita_Deal, Vineeta_Deal, Peyush_Deal, Ghazal_Deal, Total_Sharks_Involved)
SELECT DISTINCT Pitch_Number,
CASE Ashneer_Deal WHEN 1 THEN 'Yes ' ELSE 'No' END, CASE Anupam_Deal WHEN 1 THEN 'Yes' ELSE 'No' END,
CASE Aman_Deal WHEN 1 THEN 'Yes' ELSE 'No' END, CASE Namita_Deal WHEN 1 THEN 'Yes' ELSE 'No' END, 
CASE Vineeta_Deal WHEN 1 THEN 'Yes' ELSE 'No' END, CASE Peyush_Deal WHEN 1 THEN 'Yes' ELSE 'No' END,
CASE Ghazal_Deal WHEN 1 THEN 'Yes' ELSE 'No' END,
(CASE WHEN Ashneer_Deal = 1 THEN 1 ELSE 0 END +
CASE WHEN Anupam_Deal = 1 THEN 1 ELSE 0 END +
CASE WHEN Aman_Deal = 1 THEN 1 ELSE 0 END +
CASE WHEN Namita_Deal = 1 THEN 1 ELSE 0 END +
CASE WHEN Vineeta_Deal = 1 THEN 1 ELSE 0 END +
CASE WHEN Peyush_Deal = 1 THEN 1 ELSE 0 END +
CASE WHEN Ghazal_Deal = 1 THEN 1 ELSE 0 END) AS Total_Sharks_Involved
FROM Shark_Tank_India_DataSet;

-------------------------------------------------------------------------------------------------------------------------------------------------------
#CHECKING ALL THE TABLES 
Select * From Episode;
Select * From Deal;
Select * From SharksDeal;
----------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 1 - What is the total number of deals made by the sharks?

SELECT COUNT(*) AS Total_Deals_Made
FROM Deal;
-------------------------------------------------------------------------------------------------------------------------------------------------------------
#QUESTION 2 - What is the average equity asked for by pitchers in their pitches?

SELECT AVG(Ask_Equity) AS Avg_Equity
FROM Episode;
---------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 3 - What is the average valuation asked for by pitchers in their pitches?

SELECT AVG(Ask_Valuation) AS Avg_Valuation
FROM Episode;
----------------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 4 - What is the average amount of money invested by the sharks per pitch?

SELECT SUM(Deal_Amount) / COUNT(*) AS Average_Investment
FROM Deal;
---------------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 5 - What is the success rate of pitches in terms of securing a deal?
SELECT 
  COUNT(*) AS Total_Pitches,
  SUM(CASE WHEN Deal_Amount > 0 THEN 1 ELSE 0 END) AS Successful_Deals,
  SUM(CASE WHEN Deal_Amount > 0 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Success_Rate
FROM Episode
LEFT JOIN Deal ON Episode.Pitch_Number = Deal.Pitch_Number;
----------------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 6 - Which sharks are more likely to make a deal with a pitcher?
SELECT 
    'Ashneer' AS Shark_Name,
    SUM(CASE WHEN Ashneer_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
UNION
SELECT 
    'Anupam' AS Shark_Name,
    SUM(CASE WHEN Anupam_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
UNION
SELECT 
    'Aman' AS Shark_Name,
    SUM(CASE WHEN Aman_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
UNION
SELECT 
    'Namita' AS Shark_Name,
    SUM(CASE WHEN Namita_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
UNION
SELECT 
    'Vineeta' AS Shark_Name,
    SUM(CASE WHEN Vineeta_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
UNION
SELECT 
    'Peyush' AS Shark_Name,
    SUM(CASE WHEN Peyush_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
UNION
SELECT 
    'Ghazal' AS Shark_Name,
    SUM(CASE WHEN Ghazal_Deal = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS Success_Rate
FROM SharksDeal
Order by Success_Rate desc;
------------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 7 - How many pitches have each of the sharks been involved in?
SELECT 
    'Ashneer' AS Shark_Name, 
    COUNT(CASE WHEN Ashneer_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
UNION
SELECT 
    'Anupam' AS Shark_Name, 
    COUNT(CASE WHEN Anupam_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
UNION
SELECT 
    'Aman' AS Shark_Name, 
    COUNT(CASE WHEN Aman_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
UNION
SELECT 
    'Namita' AS Shark_Name, 
    COUNT(CASE WHEN Namita_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
UNION
SELECT 
    'Vineeta' AS Shark_Name, 
    COUNT(CASE WHEN Vineeta_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
UNION
SELECT 
    'Peyush' AS Shark_Name, 
    COUNT(CASE WHEN Peyush_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
UNION
SELECT 
    'Ghazal' AS Shark_Name, 
    COUNT(CASE WHEN Ghazal_Deal = 'Yes' THEN 1 END) AS Num_Deals
FROM SharksDeal
Order By  Num_Deals Desc;
------------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 8 - Who got the Highest Deal Amount (TOP 5)
SELECT Episode.Brand_Name, Episode.Idea, Deal.Deal_Amount 
FROM Episode 
INNER JOIN Deal ON Episode.Pitch_Number = Deal.Pitch_Number 
ORDER BY Deal_Amount DESC 
LIMIT 5;
---------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 9- What is the total revenue invested by the sharks in pitchers across each episodes?
SELECT e.Episode_Number, SUM(d.Deal_Amount) AS Total_Revenue_Invested
FROM Episode e
LEFT JOIN Deal d ON e.Pitch_Number = d.Pitch_Number
GROUP BY e.Episode_Number;
----------------------------------------------------------------------------------------------------------------------------------------------------------

#QUESTION 10 - What is the most common amount asked for by pitchers in their pitches?
SELECT Pitcher_Ask_Amount, COUNT(*) AS Num_Pitches
FROM Episode
GROUP BY Pitcher_Ask_Amount
ORDER BY Num_Pitches DESC
LIMIT 1;
----------------------------------------------------------------------------------------------------------------------------------------------------
