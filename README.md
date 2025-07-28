# 🏦 Bank Customer Churn Analysis
This repository contains an in-depth analysis of bank customer data to understand the factors contributing to customer churn and identify actionable insights for retention strategies.

## 🎯 Project Goal
The primary goal of this project is to:

* Identify key attributes and behaviors that differentiate churned customers from active ones.

* Explore demographic and behavioral patterns within the customer base.

* Develop insights that can help predict customer churn and inform targeted retention efforts.

## 📊 Data Source
The analysis is based on a dataset containing account information for 10,000 customers from a European bank. The dataset includes various attributes such as:

* CreditScore

* Geography (France, Spain, Germany)

* Gender

* Age

* Tenure (months as a customer)

* Balance

* NumOfProducts (number of bank products held)

* HasCrCard (whether the customer has a credit card)

* IsActiveMember (whether the customer is an active member)

* EstimatedSalary

* Exited (churn status: 1 if churned, 0 if not)

## 💡 Key Analyses & Insights
The project explores several aspects of the customer data to uncover meaningful patterns:

### Churner vs. Non-Churner Profile:

* Investigation into which attributes (e.g., balance, activity, number of products, geography, age) are more prevalent or distinct among customers who have churned compared to those who have remained with the bank.

* Initial steps towards understanding the predictability of churn using these variables.

### Overall Customer Demographics:

* Analysis of the distribution of customers across different Geography (France, Germany, Spain), Gender, and Age groups.

* Understanding the foundational composition of the bank's customer base.

### Geographical Account Behavior Comparison:

* Detailed comparison of account behavior metrics (e.g., average credit score, balance, number of products, activity status, and churn rate) among customers from Germany, France, and Spain.

* Highlighting country-specific trends and potential regional challenges or strengths.

### Customer Segmentation:

* Definition and analysis of various rule-based customer segments using attributes like AgeGroup, BalanceTier, Geography, Gender, and IsActiveMember.

* Identification of high-churn segments to prioritize retention efforts and understanding the characteristics of low-churn, loyal customer groups.

## Targeted Retention Strategies (Based on Churner Profiles & High-Churn Segments)
### Re-engage Inactive Members:

* Suggestion: Implement proactive outreach programs (e.g., personalized emails, exclusive offers) for customers identified as "inactive members" (IsActiveMember = 0), as they often show a higher propensity to churn across various segments.

* Action: Offer incentives like reduced fees, higher interest rates on savings, or a personal check-in call from a relationship manager to rekindle engagement.

### Address Senior & High-Balance Customer Churn:

* Suggestion: Investigate why "Senior" customers, especially those with "High Balance," in certain geographies (like Germany, if the data showed higher churn for this segment there) are churning. This demographic often holds significant assets.

* Action: Conduct qualitative research (surveys, interviews) with this segment to understand their pain points. Tailor loyalty programs, specialized financial advisory services, or better digital literacy support.

### Customer Service Improvement for At-Risk Groups:

* Suggestion: If certain segments (e.g., specific Balance Tiers or Age Groups) show high churn rates, review the customer service touchpoints for these groups.

* Action: Implement dedicated support channels, faster resolution times, or specialized training for agents handling these at-risk customer interactions.

## 🛠️ Technologies & Tools
SQL (MySQL): Utilized for data aggregation, complex queries, and defining customer segments using Common Table Expressions (CTEs).

## 📈 How to Explore
SQL_Queries/: Contains the SQL scripts used for demographic analysis, account behavior comparisons, and customer segmentation.

Data: Contains the Bank_Churn.csv dataset.
