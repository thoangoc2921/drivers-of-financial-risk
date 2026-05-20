SELECT
date_format(ApplicationDate, '%Y') as _year,
Case
	when LoanApproved = 1 then 'Approved'
    else 'Declined'
end as approval_status,
count(*) as	total_applicants,
round(avg(Age),2) as avg_age,
round(avg(AnnualIncome),2) as avg_income,
round(avg(TotalAssets),2) as avg_assets,
round(avg(TotalLiabilities),2) as avg_liabilities,
round(avg(SavingsAccountBalance),2) as avg_savingsaccountbalance,
round(avg(JobTenure),2) as avg_jobtenure,
round(avg(TotalDebtToIncomeRatio),2) as avg_debttoincomeratio

FROM yt_data.loan
GROUP BY 1,2
ORDER BY 1;