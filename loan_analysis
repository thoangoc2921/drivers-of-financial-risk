-- DRIVERS OF FINANCIAL RISK | LOAN APPROVAL ANALYSIS
-- Database: yt_data | Table: loan

-- ============================================================
-- PHẦN 1: SUMMARY — KPI TỔNG QUAN
-- ============================================================

-- Tổng số hồ sơ vay
SELECT COUNT(*) AS Total_Applicants FROM yt_data.loan;

-- Tổng số hồ sơ được duyệt và bị từ chối
SELECT
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    COUNT(*) - SUM(LoanApproved) AS Total_Declined,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct
FROM yt_data.loan;

-- Tỷ lệ phê duyệt theo từng năm + YoY Change
SELECT
    DATE_FORMAT(ApplicationDate, '%Y') AS _year,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct
FROM yt_data.loan
GROUP BY 1
ORDER BY 1;


-- ============================================================
-- PHẦN 2: RISK FACTORS — CÁC YẾU TỐ RỦI RO
-- ============================================================

-- So sánh trung bình các chỉ số tài chính giữa Approved vs Declined
SELECT
    CASE
        WHEN LoanApproved = 1 THEN 'Approved'
        ELSE 'Declined'
    END AS Approval_Status,
    COUNT(*) AS Total_Applicants,
    ROUND(AVG(AnnualIncome), 2) AS Avg_Annual_Income,
    ROUND(AVG(CreditScore), 2) AS Avg_Credit_Score,
    ROUND(AVG(TotalDebtToIncomeRatio), 2) AS Avg_DTI,
    ROUND(AVG(TotalAssets), 2) AS Avg_Total_Assets,
    ROUND(AVG(TotalLiabilities), 2) AS Avg_Total_Liabilities,
    ROUND(AVG(NetWorth), 2) AS Avg_Net_Worth,
    ROUND(AVG(SavingsAccountBalance), 2) AS Avg_Savings_Balance,
    ROUND(AVG(JobTenure), 2) AS Avg_Job_Tenure,
    ROUND(AVG(RiskScore), 2) AS Avg_Risk_Score
FROM yt_data.loan
GROUP BY LoanApproved;

-- Phân tầng Credit Tier theo CreditScore + tỷ lệ phê duyệt theo từng tier
SELECT
    CASE
        WHEN CreditScore >= 622 THEN 'Tier 1-2 | Excellent (622+)'
        WHEN CreditScore BETWEEN 570 AND 621 THEN 'Tier 3-4 | Good (570-621)'
        WHEN CreditScore BETWEEN 545 AND 569 THEN 'Tier 5-6 | Fair (545-569)'
        WHEN CreditScore BETWEEN 455 AND 544 THEN 'Tier 7-8 | High Risk (455-544)'
        ELSE 'Tier 9-10 | Very Poor (403-454)'
    END AS Credit_Tier,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    COUNT(*) - SUM(LoanApproved) AS Total_Declined,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct
FROM yt_data.loan
GROUP BY 1
ORDER BY MIN(CreditScore) DESC;

-- Phân tích theo Employment Status
SELECT
    EmploymentStatus,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct,
    ROUND(AVG(AnnualIncome), 2) AS Avg_Income,
    ROUND(AVG(CreditScore), 2) AS Avg_Credit_Score
FROM yt_data.loan
GROUP BY EmploymentStatus
ORDER BY Approval_Rate_Pct DESC;

-- Phân tích theo Home Ownership Status
SELECT
    HomeOwnershipStatus,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct,
    ROUND(AVG(TotalAssets), 2) AS Avg_Total_Assets
FROM yt_data.loan
GROUP BY HomeOwnershipStatus
ORDER BY Approval_Rate_Pct DESC;

-- Phân tích theo Loan Purpose
SELECT
    LoanPurpose,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct,
    ROUND(AVG(LoanAmount), 2) AS Avg_Loan_Amount,
    ROUND(AVG(InterestRate), 4) AS Avg_Interest_Rate
FROM yt_data.loan
GROUP BY LoanPurpose
ORDER BY Total_Applicants DESC;

-- Phân tích theo Education Level
SELECT
    EducationLevel,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct,
    ROUND(AVG(AnnualIncome), 2) AS Avg_Income
FROM yt_data.loan
GROUP BY EducationLevel
ORDER BY Approval_Rate_Pct DESC;

-- Phân tích rủi ro: Bankruptcy History và Previous Loan Defaults
SELECT
    BankruptcyHistory,
    PreviousLoanDefaults,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct,
    ROUND(AVG(RiskScore), 2) AS Avg_Risk_Score
FROM yt_data.loan
GROUP BY BankruptcyHistory, PreviousLoanDefaults
ORDER BY BankruptcyHistory, PreviousLoanDefaults;


-- ============================================================
-- PHẦN 3: YOY TREND — XU HƯỚNG THEO NĂM
-- ============================================================

-- Approval Rate theo từng năm kèm so sánh năm trước (dùng subquery)
SELECT
    DATE_FORMAT(ApplicationDate, '%Y') AS _year,
    COUNT(*) AS Total_Applicants,
    SUM(LoanApproved) AS Total_Approved,
    ROUND(SUM(LoanApproved) * 100.0 / COUNT(*), 2) AS Approval_Rate_Pct,
    ROUND(AVG(AnnualIncome), 2) AS Avg_Income,
    ROUND(AVG(CreditScore), 2) AS Avg_Credit_Score,
    ROUND(AVG(TotalDebtToIncomeRatio), 2) AS Avg_DTI,
    ROUND(AVG(TotalAssets), 2) AS Avg_Assets,
    ROUND(AVG(TotalLiabilities), 2) AS Avg_Liabilities,
    ROUND(AVG(SavingsAccountBalance), 2) AS Avg_Savings_Balance,
    ROUND(AVG(JobTenure), 2) AS Avg_Job_Tenure
FROM yt_data.loan
GROUP BY 1
ORDER BY 1;
