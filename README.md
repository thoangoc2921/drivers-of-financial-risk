# 📊 Drivers of Financial Risk | SQL + Power BI

> **76% hồ sơ vay bị từ chối — nhưng điều gì thực sự quyết định kết quả đó?**
> Project phân tích 20,000 hồ sơ vay để xác định các yếu tố tài chính thực sự phân biệt hồ sơ được duyệt và bị từ chối — kết quả cho thấy thu nhập có sức ảnh hưởng lớn hơn Credit Score rất nhiều, trong khi DTI (thường được coi là chỉ số quan trọng) lại không có bất kỳ sự khác biệt nào giữa hai nhóm.

---

## 1. Project Overview

Các tổ chức tín dụng thường xuyên từ chối phần lớn hồ sơ vay, nhưng tiêu chí đằng sau những quyết định đó thường không minh bạch — ngay cả trong nội bộ. Nếu không hiểu rõ tín hiệu tài chính nào thực sự quyết định việc phê duyệt, người cho vay đối mặt với hai rủi ro đồng thời: chấp thuận hồ sơ rủi ro cao và từ chối hồ sơ có khả năng trả nợ tốt.

Project phân tích 20,000 hồ sơ vay tổng hợp trong giai đoạn 2018–2072 để trả lời một câu hỏi kinh doanh cốt lõi: **yếu tố tài chính nào phân biệt rõ nhất giữa hồ sơ được duyệt và bị từ chối?** Sử dụng MySQL để tính toán tổng hợp theo nhóm và Power BI để xây dựng dashboard tương tác 3 trang, phân tích cho thấy một phát hiện đáng chú ý — thu nhập giải thích khoảng cách phê duyệt nhiều hơn Credit Score rất nhiều, trong khi DTI (một chỉ số thường được trích dẫn) lại bằng nhau hoàn toàn giữa hai nhóm.

Kết quả là một dashboard cho phép đội ngũ chính sách tín dụng kiểm tra các pattern phê duyệt theo năm, Credit Tier và trạng thái phê duyệt — cùng với các khuyến nghị dựa trên dữ liệu thực tế, không phải giả định thông thường.

---

## 2. Objectives

- Xác định biến tài chính nào (thu nhập, Credit Score, DTI, tài sản, nợ phải trả, tiết kiệm, thâm niên làm việc) phân biệt rõ nhất giữa hồ sơ được duyệt và bị từ chối
- Định lượng khoảng cách phê duyệt qua 5 Credit Tier (Excellent → Very Poor) để xác định liệu Credit Score đơn lẻ có đủ để dự đoán kết quả không
- Theo dõi thay đổi Approval Rate theo từng năm (2018–2072) để phát hiện thay đổi chính sách hoặc các chu kỳ biến động
- Xây dựng Power BI dashboard tương tác 3 trang với filter theo Year, Credit Tier và Approval Label
- Ghi nhận các vấn đề chất lượng dữ liệu (ví dụ: DTI bằng nhau giữa 2 nhóm) cần được điều tra trước khi mô hình có thể được tin cậy cho các quyết định chính sách

---

## 3. Project Scope & Tools

| Hạng mục | Chi tiết |
|----------|----------|
| **Dataset** | 20,000 hồ sơ vay — 1 bảng `loan`, 36 cột |
| **Nguồn dữ liệu** | Dataset tổng hợp (Kaggle) — mô phỏng hành vi tín dụng, không phải dữ liệu thực tế |
| **Thời gian dữ liệu** | 2018–2072 |
| **SQL** | MySQL — GROUP BY year × approval_status, tính average các chỉ số tài chính, phân tầng Credit Tier |
| **Visualization** | Power BI Desktop — 3 trang: Summary / Risk Factors / YoY Trend |
| **DAX** | Approval Rate, PY Approval Rate, YoY Approval Rate Change |
| **File output** | `.sql`, `.csv`, `.pdf` (export dashboard) |

---

## 4. Repository Structure

```text
drivers-of-financial-risk/
├── queries/
│   ├── exploratory/
│   │   └── loan_analysis.sql               # Phân tích theo năm × approval status
│   └── transformations/
│       └── credit_tier_classification.sql  # Phân tầng Credit Tier từ CreditScore
├── data/
│   └── raw/
│       └── Loan.csv                        # Dataset gốc (20,000 records, 36 columns)
├── reports/
│   └── Drivers_of_financial_risk.pdf       # Export Power BI dashboard (3 trang)
├── visuals/
│   ├── summary_page.png
│   ├── risk_factors_page.png
│   └── yoy_trend_page.png
└── README.md
```

---

## 5. Data Workflow

```text
Raw Data
└── Loan.csv (20,000 records × 36 columns — Kaggle synthetic dataset)
        │
        ▼
[MySQL — Exploratory Query]
    GROUP BY year × approval_status
    → avg income, assets, liabilities, DTI, savings, job tenure
        │
        ▼
[MySQL — Transformation Query]
    CASE WHEN CreditScore → Credit Tier (5 nhóm: Excellent → Very Poor)
    → approval count, avg income by Tier
        │
        ▼
[Power BI — Import & Model]
    Tạo cột Approval Label
    Tính DAX measures: Approval Rate, PY Approval Rate, YoY Change
        │
        ▼
[Power BI — Dashboard]
    Trang 1: Summary (KPI cards + Approval Rate theo từng năm)
    Trang 2: Risk Factors (phân tích Credit Tier + so sánh Approved vs Declined)
    Trang 3: YoY Trend (bảng theo từng năm + đường xu hướng so với trung bình)
    Filters: Year slicer, Credit Tier, Approval Label
```

---

## 6. Data Model & Schema

**Bảng duy nhất:** `yt_data.loan` — không có join, không có ERD

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `ApplicationDate` | DATE | Ngày nộp hồ sơ vay |
| `Age` | INT | Tuổi người vay |
| `AnnualIncome` | INT | Thu nhập hàng năm (USD) |
| `CreditScore` | INT | Điểm tín dụng (403–750+) |
| `EmploymentStatus` | VARCHAR | Tình trạng việc làm |
| `EducationLevel` | VARCHAR | Trình độ học vấn |
| `LoanAmount` | INT | Số tiền vay (USD) |
| `LoanDuration` | INT | Thời hạn vay (tháng) |
| `DebtToIncomeRatio` | FLOAT | Tỷ lệ nợ/thu nhập (khoản vay hiện tại) |
| `TotalDebtToIncomeRatio` | FLOAT | Tổng tỷ lệ nợ/thu nhập (toàn bộ các khoản nợ) |
| `BankruptcyHistory` | INT | Lịch sử phá sản (0 = Không, 1 = Có) |
| `PreviousLoanDefaults` | INT | Số lần vỡ nợ trước đây |
| `SavingsAccountBalance` | INT | Số dư tài khoản tiết kiệm (USD) |
| `TotalAssets` | INT | Tổng tài sản (USD) |
| `TotalLiabilities` | INT | Tổng nợ phải trả (USD) |
| `JobTenure` | INT | Số năm làm việc tại công ty hiện tại |
| `NetWorth` | INT | Giá trị tài sản ròng (USD) |
| `RiskScore` | FLOAT | Điểm rủi ro do hệ thống tính toán |
| `LoanApproved` | INT | Kết quả phê duyệt (1 = Approved, 0 = Declined) |

---

## 7. Analysis & Metrics

### Key Metrics

| Metric | Giá trị | Ghi chú |
|--------|---------|---------|
| Total Applicants | 20,000 | Tổng hồ sơ trong dataset |
| Approval Rate | 23.90% | Chỉ ~1 trong 4 hồ sơ được phê duyệt |
| Total Approved | 4,800 | |
| Total Declined | 15,200 | |
| YoY Approval Rate Change (avg) | −0.02% | Gần như phẳng — không có xu hướng rõ ràng |

### Approved vs. Declined — So sánh chỉ số tài chính

| Chỉ số | Approved | Declined | Chênh lệch |
|--------|----------|----------|-----------|
| Avg Annual Income | $102,211 | $45,641 | **+$56,570** |
| Avg Credit Score | 584.53 | 567.55 | +16.98 điểm |
| Avg DTI | 28.57% | 28.57% | **0 — không có sự khác biệt** |

### Credit Tier Classification & Approval Count

| Tier | Credit Score | Approved | Declined | Approval Rate (ước tính) |
|------|-------------|----------|----------|--------------------------|
| Tier 1-2 \| Excellent | 622+ | 1,100 | 2,000 | ~35% |
| Tier 3-4 \| Good | 570–621 | 2,000 | 6,200 | ~24% |
| Tier 5-6 \| Fair | 545–569 | 700 | 4,100 | ~15% |
| Tier 7-8 \| High Risk | 455–544 | 900 | 2,600 | ~26% |
| Tier 9-10 \| Very Poor | 403–454 | 100 | 400 | ~20% |

### SQL — Query 1: Phân tích theo năm × Approval Status

```sql
SELECT
    DATE_FORMAT(ApplicationDate, '%Y') AS _year,
    CASE
        WHEN LoanApproved = 1 THEN 'Approved'
        ELSE 'Declined'
    END AS approval_status,
    COUNT(*) AS total_applicants,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(AnnualIncome), 2) AS avg_income,
    ROUND(AVG(TotalAssets), 2) AS avg_assets,
    ROUND(AVG(TotalLiabilities), 2) AS avg_liabilities,
    ROUND(AVG(SavingsAccountBalance), 2) AS avg_savingsaccountbalance,
    ROUND(AVG(JobTenure), 2) AS avg_jobtenure,
    ROUND(AVG(TotalDebtToIncomeRatio), 2) AS avg_debttoincomeratio
FROM yt_data.loan
GROUP BY 1, 2
ORDER BY 1;
```

*Tạo bảng so sánh chỉ số tài chính theo từng năm và trạng thái phê duyệt — dữ liệu đầu vào chính để Power BI vẽ biểu đồ Risk Factors và YoY Trend.*

### SQL — Query 2: Phân tầng Credit Tier

```sql
SELECT
    CASE
        WHEN CreditScore >= 622 THEN 'Tier 1-2 | Excellent'
        WHEN CreditScore BETWEEN 570 AND 621 THEN 'Tier 3-4 | Good'
        WHEN CreditScore BETWEEN 545 AND 569 THEN 'Tier 5-6 | Fair'
        WHEN CreditScore BETWEEN 455 AND 544 THEN 'Tier 7-8 | High Risk'
        ELSE 'Tier 9-10 | Very Poor'
    END AS credit_tier,
    SUM(LoanApproved) AS total_approved,
    COUNT(*) - SUM(LoanApproved) AS total_declined,
    ROUND(AVG(AnnualIncome), 2) AS avg_income,
    ROUND(AVG(CreditScore), 2) AS avg_credit_score
FROM yt_data.loan
GROUP BY 1
ORDER BY MIN(CreditScore) DESC;
```

*Phân nhóm hồ sơ theo Credit Score thành 5 tầng rủi ro — phục vụ trang Risk Factors trong dashboard.*

---

## 8. Key Insights

### 💰 Thu nhập là yếu tố phân biệt mạnh nhất — không phải Credit Score

Nhóm Approved có thu nhập trung bình $102,211 — gấp hơn 2 lần nhóm Declined ($45,641). Trong khi đó, chênh lệch Credit Score chỉ là 17 điểm (584 vs 568) — quá nhỏ để giải thích Approval Rate chỉ đạt 23.9%. Điều này gợi ý mô hình phê duyệt đang ưu tiên **khả năng trả nợ dựa trên thu nhập** hơn là lịch sử tín dụng — một lựa chọn có thể có lý do chiến lược, nhưng cần được kiểm tra kỹ trước khi coi là chính sách tối ưu.

### 📉 DTI bằng nhau hoàn toàn giữa 2 nhóm — đây là tín hiệu cần điều tra, không phải kết luận

Avg DTI của cả Approved lẫn Declined đều là 28.57% — không có bất kỳ sự khác biệt nào. DTI thường được coi là chỉ số thẩm định tín dụng quan trọng, vì vậy kết quả này bất thường và có hai cách giải thích: (1) mô hình phê duyệt thực sự không dùng DTI làm điều kiện lọc, hoặc (2) có vấn đề trong cách tính `TotalDebtToIncomeRatio` trong dataset. Cần xác minh trước khi rút ra kết luận về vai trò của DTI.

### 🏆 Ngay cả nhóm Excellent Credit (622+) vẫn bị từ chối nhiều hơn được duyệt

Tier Excellent (622+) có 1,100 Approved nhưng 2,000 Declined — Approval Rate chỉ khoảng 35% dù có Credit Score cao nhất. Điều này xác nhận Credit Score không phải điều kiện đủ: hồ sơ có lịch sử tín dụng tốt nhưng thu nhập chưa đạt ngưỡng vẫn bị từ chối với tỷ lệ cao. **Thu nhập quan trọng hơn Credit Tier.**

### 📊 Approval Rate dao động lớn nhưng không theo xu hướng rõ ràng

Approval Rate biến động từ ~19% (thấp nhất) đến ~31% (đỉnh năm 2055), với YoY Change trung bình −0.02%. Không có xu hướng tăng hoặc giảm bền vững. Điều này có thể phản ánh: chính sách tín dụng thay đổi theo chu kỳ, hoặc các yếu tố vĩ mô chưa được ghi nhận trong dataset hiện tại.

### 📉 Tỷ lệ từ chối 76.1% đặt ra câu hỏi về false negatives

Với 15,200/20,000 hồ sơ bị Declined, câu hỏi quan trọng là: trong số đó có bao nhiêu hồ sơ thực ra có khả năng trả nợ tốt nhưng bị loại vì thu nhập thấp hơn ngưỡng? Dataset hiện tại không có outcome thực (vỡ nợ hay trả đủ), nên chưa thể đánh giá độ chính xác của mô hình phê duyệt.

---

## 9. Recommendations

**1. Kiểm tra lại vai trò của thu nhập trong mô hình phê duyệt**

Chênh lệch thu nhập $56K giữa 2 nhóm cho thấy income đang chiếm vai trò áp đảo trong quyết định phê duyệt. Đội Risk Management nên xem xét liệu mô hình hiện tại có đang bỏ qua các tín hiệu tích cực khác không — ví dụ: lịch sử thanh toán sạch, số dư tiết kiệm cao, thâm niên làm việc dài. Mục tiêu: giảm false negative rate 5–10% trong nhóm thu nhập $40K–$70K có lịch sử thanh toán tốt (0 defaults), mà không làm tăng default rate. *[Đội Risk Management & Credit Policy]*

**2. Điều tra nguyên nhân DTI không phân biệt được 2 nhóm**

Avg DTI = 28.57% ở cả 2 nhóm là bất thường và cần được xác minh trước khi sử dụng chỉ số này trong bất kỳ mô hình nào. Đội Data cần kiểm tra: cách tính `TotalDebtToIncomeRatio`, liệu có truncation hoặc normalization nào đã được áp dụng trong dataset gốc không, và DTI có thực sự được dùng trong logic phê duyệt hay không. *[Đội Data Engineering]*

**3. Thiết lập chính sách riêng theo Credit Tier thay vì áp dụng một ngưỡng chung**

Thay vì một ngưỡng thu nhập áp dụng đồng đều cho tất cả, xem xét tiêu chí phân tầng: Tier 1-2 (Excellent, 622+) có thể được nới lỏng yêu cầu thu nhập tối thiểu do rủi ro tín dụng thấp hơn; Tier 7-8 (High Risk) cần yêu cầu tài sản đảm bảo hoặc co-signer. Thành công đo bằng: Approval Rate nhóm Excellent tăng từ ~35% lên ~45% mà không làm tăng default rate trong nhóm này. *[Đội Credit Policy]*

**4. Phân tích sâu các năm có Approval Rate đột biến**

Năm 2055 có Approval Rate cao nhất (~31%) và một số năm xuống dưới 20% — khoảng cách 12 điểm phần trăm trong cùng một dataset là đáng kể. Cần xác định nguyên nhân (thay đổi chính sách nội bộ, điều kiện kinh tế mô phỏng, thay đổi trong phân phối hồ sơ?) để rút ra bài học cho chu kỳ tiếp theo. *[Đội Strategy & Planning]*

---

## 10. Assumptions & Limitations

**Assumptions:**

- Dataset là tổng hợp (Kaggle) — các pattern được tạo ra bởi thuật toán mô phỏng và có thể không phản ánh đầy đủ thực tế thị trường tín dụng, đặc biệt về mối quan hệ phi tuyến giữa các biến
- `LoanApproved = 1` là Approved, `= 0` là Declined — không có trạng thái trung gian (pending, withdrawn, conditional approval)
- Các ngưỡng Credit Tier (622, 570, 545, 455, 403) được định nghĩa cho mục đích phân tích của project này, không theo chuẩn FICO chính thức

**Limitations:**

- **Không có loan outcome thực:** Dataset không theo dõi việc người vay có trả được nợ không sau khi được duyệt — vì vậy không thể đánh giá chất lượng mô hình phê duyệt (precision/recall trên bad loans)
- **SQL chỉ tính average:** Các query hiện tại chỉ tính mean — không phản ánh được phân phối thực sự (outliers, độ lệch) của income, Credit Score và các biến tài chính khác
- **DTI anomaly chưa được giải thích:** DTI bằng nhau giữa 2 nhóm cần xác minh chất lượng dữ liệu trước khi kết luận
- **Không có thông tin địa lý:** Không thể phân tích theo khu vực, tiểu bang, hay điều kiện thị trường địa phương
- **Thời gian dữ liệu kéo đến 2072:** Dataset mô phỏng nhiều thập kỷ trong tương lai — không phải dự báo thực tế, và các pattern có thể không nhất quán với hành vi tín dụng trong thực tế

---

## 11. Future Enhancements

- Bổ sung phân tích phân phối (histogram, boxplot) cho Income và Credit Score theo từng Tier để xem outlier ảnh hưởng thế nào đến average
- Xây dựng mô hình Logistic Regression để dự đoán `LoanApproved` và đo feature importance — kiểm tra lại xem income có thực sự là top predictor không
- Phân tích hành vi thanh toán theo Tier nếu có thêm dữ liệu outcome (default rate by tier)
- Bổ sung phân tích theo `EmploymentStatus` và `EducationLevel` để kiểm tra bias tiềm ẩn trong mô hình phê duyệt

---

## 12. Deliverables

- ✅ `queries/exploratory/loan_analysis.sql` — Phân tích theo năm × approval status
- ✅ `queries/transformations/credit_tier_classification.sql` — Phân tầng Credit Tier
- ✅ `data/raw/Loan.csv` — Dataset gốc (20,000 records, 36 columns)
- ✅ `reports/Drivers_of_financial_risk.pdf` — Export Power BI dashboard (3 trang)
- ✅ `README.md` — Tài liệu project đầy đủ

---

## 13. Author

**Phan Ngoc Kim Thoa**

- 📧 thoaphan2921@gmail.com
- 💼 [LinkedIn](https://www.linkedin.com/in/thoangoc2906)
- 🐙 [GitHub](https://github.com/thoangoc2921)
