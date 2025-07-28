USE bank;

CREATE TABLE BankCustomers (
    CustomerId INT,
    Surname VARCHAR(255),
    CreditScore INT,
    Geography VARCHAR(255),
    Gender VARCHAR(255),
    Age INT,
    Tenure INT,
    Balance DECIMAL(15, 2), -- Using DECIMAL for financial data, 15 total digits, 2 after decimal
    NumOfProducts INT,
    HasCrCard TINYINT,      -- TINYINT for 0/1 (boolean-like)
    IsActiveMember TINYINT, -- TINYINT for 0/1
    EstimatedSalary DECIMAL(15, 2),
    Exited TINYINT         
    );
    
    SELECT * From bankcustomers;
    
LOAD DATA INFILE 'D:/mysql/Bank_Churn.csv' -- **IMPORTANT: Replace with the actual full path to your CSV file**
INTO TABLE bankcustomers
FIELDS TERMINATED BY ','     -- Specifies that columns are separated by commas
ENCLOSED BY '"'              -- Specifies that field values might be enclosed by double quotes (if your data has commas within text fields, though not strictly needed for this CSV)
LINES TERMINATED BY '\r\n'   -- Specifies that lines end with a carriage return and newline (common for Windows CSVs)
IGNORE 1 LINES;              -- Skips the first line (the header row in your CSV)

-- Numeric Attributes comparison : churners VS non-churners 

SELECT 
   Exited,
   AVG(CreditScore) AS AvgCreditScore,
   AVG(Age) AS AvrAge,
   AVG(Tenure) AS AvgTenure,
   AVG(Balance) AS AvgBalance,
   AVG(EstimatedSalary) AS AvgEstimatedSalary
   FROM 
   bankcustomers
   GROUP BY Exited
   ;

-- Distribution of categorical column

SELECT 
 Exited,
 Geography,
 COUNT(*) AS CustomerCount,
(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM BankCustomers WHERE Exited = T.Exited AND Geography = T.Geography)) AS ProportionPerCountryAndExitedStatus -- This is tricky in pure SQL for exact proportions of each group
FROM
  bankcustomers AS T
GROUP BY 
Exited,
Geography
ORDER BY 
Exited, Geography;

-- By Geography
SELECT 
 Geography,
 AVG(Exited) AS Churnrate
 FROM bankcustomers 
 GROUP BY 
 Geography;
 
 -- by gender
 
 SELECT
  Gender,
  Exited,
  COUNT(*) AS CustomerCount
  FROM 
  bankcustomers
  GROUP BY 
  GENDER,
  Exited
  ORDER BY 
  Gender,
  Exited ;
  -- churnrate by gender
  SELECT 
  Gender,
  AVG(Exited) AS Churnrate 
  FROM 
  bankcustomers
  GROUP BY 
  Gender;
  
  -- distribution by Has credit card
  SELECT 
  HasCrCard,
  Exited,
  COUNT(*) AS CustomerCount
  FROM 
  bankcustomers
  GROUP BY 
  HasCrCard,
  Exited
  Order By 
  HasCrCard,
  Exited;
  
-- churn rate by has credit card
SELECT 
HasCrCard,
AVG(Exited) AS ChurnRate
FROM 
bankcustomers
Group by 
HasCrCard ;

-- Distribution by Is active member
SELECT 
Exited,
IsActiveMember,
COUNT(*) AS CustomerCount
FROM 
bankcustomers
GROUP BY 
Exited, IsActiveMember ;

-- churn by isactivemember
SELECT
IsActiveMember,
Avg(Exited) AS Churnrate
FROM 
bankcustomers
GROUP BY IsActiveMember; 

-- Q2.What do the overall demographics of the bank's customers look like?
-- geography
  SELECT
    Geography,
    COUNT(*) AS CustomerCount,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM BankCustomers)) AS Percentage
FROM
    BankCustomers
GROUP BY
    Geography
ORDER BY
    CustomerCount DESC;
    
    -- USING CTES
    With TotalCustomers AS 
    (
      SELECT COUNT(*) AS TotalCount
      FROM bankcustomers 
	)
    SELECT 
     bc.Geography,
     COUNT(bc.CustomerID) AS Customercount,
     (COUNT(bc.CustomerID) * 100.0/ tc.TotalCount) AS Percentage
     FROM
     bankcustomers bc , 
     Totalcustomers tc
     GROUP BY
     Geography,
     Totalcount;
     
     -- gender
     
     WITH Totalcustomers AS
     (
     SELECT COUNT(*) AS Totalcount
	 FROM bankcustomers
      )
      SELECT 
      bc.gender,
      COUNT(bc.CustomerID) AS Customercount,
      (COUNT(bc.CustomerID)* 100.0/tc.Totalcount) AS Percentage
      FROM
      bankcustomers bc,
      Totalcustomers tc
      GROUP BY 
      bc.gender,
      tc.Totalcount;
      
      -- age
      SELECT 
      COUNT(Age) AS Totalcustomer,
      MIN(Age) AS MinAge,
      MAX(Age) AS Maxage,
      AVG(Age)AS Averageage,
      STDDEV(Age) AS Standarddeviationage
      FROM 
      bankcustomers;
      
  -- Q3.Is there a difference between German, French, and Spanish customers in terms of account behavior?
  
SELECT
    Geography,
    COUNT(*) AS TotalCustomers,
    AVG(CreditScore) AS AvgCreditScore,
    AVG(Age) AS AvgAge,
    AVG(Tenure) AS AvgTenure,
    AVG(Balance) AS AvgBalance,
    AVG(NumOfProducts) AS AvgNumOfProducts,
    AVG(HasCrCard) AS ProportionHasCrCard,
    AVG(IsActiveMember) AS ProportionIsActiveMember,
    AVG(Exited) AS ChurnRate
FROM
    BankCustomers
GROUP BY
    Geography
ORDER BY
    ChurnRate DESC; 
    
    SELECT
    Geography,
    COUNT(*) AS CustomerCount,
    -- Calculate percentage using a window function for total count
    (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()) AS Percentage
FROM
    BankCustomers
GROUP BY
    Geography
ORDER BY
    CustomerCount DESC;

-- Q4. What types of segments exist within the bank's customers?
-- CTE 1: Define Age Segments
WITH CustomerAgeSegments AS (
    SELECT
        CustomerId,
        Age,
        CASE
            WHEN Age < 30 THEN 'Young'
            WHEN Age >= 30 AND Age < 50 THEN 'Middle-Aged'
            WHEN Age >= 50 AND Age < 65 THEN 'Senior'
            ELSE 'Elderly' -- Ages 65+
        END AS AgeGroup
    FROM
        BankCustomers
),
-- CTE 2: Define Balance Segments (using predefined tiers)
CustomerBalanceSegments AS (
    SELECT
        CustomerId,
        Balance,
        CASE
            WHEN Balance = 0 THEN 'No Balance'
            WHEN Balance > 0 AND Balance <= 50000 THEN 'Low Balance'
            WHEN Balance > 50000 AND Balance <= 100000 THEN 'Medium Balance'
            ELSE 'High Balance' -- Balances over 100,000
        END AS BalanceTier
    FROM
        BankCustomers
),
-- CTE 3: Combine all relevant customer attributes and their derived segments
SegmentedCustomers AS (
    SELECT
        bc.CustomerId,
        cas.AgeGroup,
        cbs.BalanceTier,
        bc.Geography,
        bc.Gender,
        bc.IsActiveMember,
        bc.Exited, -- Include churn status for segment analysis
        bc.NumOfProducts -- Include number of products
    FROM
        BankCustomers bc
    JOIN
        CustomerAgeSegments cas ON bc.CustomerId = cas.CustomerId
    JOIN
        CustomerBalanceSegments cbs ON bc.CustomerId = cbs.CustomerId
)
-- Final SELECT: Analyze the combined segments
SELECT
    s.AgeGroup,
    s.BalanceTier,
    s.Geography,
    s.Gender,
    s.IsActiveMember,
    COUNT(s.CustomerId) AS SegmentCount,
    AVG(s.Exited) AS ChurnRateInSegment, -- Average of 'Exited' (0 or 1) gives churn rate
    AVG(s.NumOfProducts) AS AvgProductsInSegment
FROM
    SegmentedCustomers s
GROUP BY
    s.AgeGroup,
    s.BalanceTier,
    s.Geography,
    s.Gender,
    s.IsActiveMember
ORDER BY
    ChurnRateInSegment DESC, SegmentCount DESC;





