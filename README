# 📊 Drivers of Financial Risk | SQL + Power BI

## 1. Project Overview

Các tổ chức tín dụng phải đối mặt với thách thức xác định yếu tố nào thực sự ảnh hưởng đến quyết định phê duyệt khoản vay và mức độ rủi ro tài chính của người vay. Project này phân tích 20,000 hồ sơ vay từ 2018–2072 nhằm xác định các driver chính dẫn đến việc bị từ chối (Declined) — bao gồm thu nhập, credit score, DTI, và lịch sử tín dụng. Kết quả: dashboard 3 tầng (Summary / Risk Factors / YoY Trend) trên Power BI cho thấy tỷ lệ phê duyệt tổng chỉ đạt 23.90%, với khoảng cách thu nhập giữa nhóm Approved và Declined lên tới hơn $56,000.

---

## 2. Objectives

- Xác định các yếu tố tài chính phân biệt rõ nhất giữa hồ sơ được duyệt và bị từ chối (thu nhập, credit score, DTI, tài sản, lịch sử thanh toán)
- Phân tích xu hướng tỷ lệ phê duyệt theo từng năm (YoY Approval Rate Change)
- Phân tầng rủi ro tín dụng theo Credit Tier (Excellent / Good / Fair / High Risk / Very Poor)
- Xây dựng dashboard tương tác hỗ trợ lọc theo Year, Credit Tier, Approval Label

---

## 3. Project Scope & Tools

| Hạng mục | Chi tiết |
|----------|----------|
| **Dataset** | 20,000 hồ sơ vay — 1 bảng `loan` |
| **Thời gian dữ liệu** | 2018–2072 (synthetic dataset) |
| **SQL** | MySQL — phân tích theo năm, approval status, các chỉ số tài chính trung bình |
| **Visualization** | Power BI Desktop — 3 trang báo cáo |
| **File type** | `.sql`, `.csv`, `.pdf` (report export) |

---

## 4. Repository Structure

```text
drivers-of-financial-risk/
├── queries/
│   └── loan_analysis.sql          # SQL query phân tích theo năm và approval status
├── data/
│   └── Loan.csv                   # Dataset gốc (20,000 records)
├── reports/
│   └── Drivers_of_financial_risk.pdf  # Export Power BI dashboard
├── visuals/
│   ├── summary_page.png
│   ├── risk_factors_page.png
│   └── yoy_trend_page.png
└── README.md
```

---

## 5. Data Workflow

```text
Raw Data (Loan.csv — 20,000 records, 36 columns)
        ↓
[MySQL] GROUP BY year + approval_status → avg income, assets, liabilities, DTI, job tenure
        ↓
[Power BI] Import → Tạo Credit Tier từ CreditScore (phân tầng 5 nhóm)
        ↓
[Power BI] Tính Approval Rate, YoY Change bằng DAX
        ↓
[Power BI] Xây dựng 3-page dashboard với filter: Year, Credit Tier, Approval Label
```

---

## 6. Data Model & Schema

**Bảng duy nhất:** `yt_data.loan`

| Cột | Kiểu dữ liệu | Mô tả |
|-----|-------------|-------|
| `ApplicationDate` | DATE | Ngày nộp hồ sơ vay |
| `Age` | INT | Tuổi người vay |
| `AnnualIncome` | INT | Thu nhập hàng năm |
| `CreditScore` | INT | Điểm tín dụng |
| `EmploymentStatus` | VARCHAR | Tình trạng việc làm |
| `EducationLevel` | VARCHAR | Trình độ học vấn |
| `LoanAmount` | INT | Số tiền vay |
| `LoanDuration` | INT | Thời hạn vay (tháng) |
| `DebtToIncomeRatio` | FLOAT | Tỷ lệ nợ/thu nhập |
| `TotalDebtToIncomeRatio` | FLOAT | Tổng tỷ lệ nợ/thu nhập |
| `BankruptcyHistory` | INT | Lịch sử phá sản (0/1) |
| `PreviousLoanDefaults` | INT | Số lần vỡ nợ trước đây |
| `SavingsAccountBalance` | INT | Số dư tài khoản tiết kiệm |
| `TotalAssets` | INT | Tổng tài sản |
| `TotalLiabilities` | INT | Tổng nợ phải trả |
| `JobTenure` | INT | Số năm làm việc tại công ty hiện tại |
| `NetWorth` | INT | Giá trị tài sản ròng |
| `RiskScore` | FLOAT | Điểm rủi ro do hệ thống tính |
| `LoanApproved` | INT | Kết quả phê duyệt (1 = Approved, 0 = Declined) |

---

## 7. Analysis & Metrics

### Key Metrics

| Metric | Giá trị | Ghi chú |
|--------|---------|---------|
| **Total Applicants** | 20,000 | Tổng hồ sơ vay |
| **Approval Rate** | 23.90% | Tỷ lệ được phê duyệt |
| **Total Approved** | 4,800 | Hồ sơ được duyệt |
| **Total Declined** | 15,200 | Hồ sơ bị từ chối |
| **YoY Approval Rate Change** | -0.02% | Thay đổi trung bình hàng năm |

### So sánh Approved vs Declined

| Chỉ số | Approved | Declined | Chênh lệch |
|--------|----------|----------|-----------|
| **Avg Annual Income** | $102,211 | $45,641 | +$56,570 |
| **Avg Credit Score** | 584.53 | 567.55 | +16.98 điểm |
| **Avg DTI** | 28.57% | 28.57% | Không có sự khác biệt |

### Credit Tier Classification

| Tier | Credit Score | Approved | Declined |
|------|-------------|----------|----------|
| Tier 1-2 \| Excellent | 622+ | 1,100 | 2,000 |
| Tier 3-4 \| Good | 570–621 | 2,000 | 6,200 |
| Tier 5-6 \| Fair | 545–569 | 700 | 4,100 |
| Tier 7-8 \| High Risk | 455–544 | 900 | 2,600 |
| Tier 9-10 \| Very Poor | 403–454 | 100 | 400 |

### SQL Logic

```sql
SELECT
    date_format(ApplicationDate, '%Y') as _year,
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

*Query này nhóm dữ liệu theo năm và trạng thái phê duyệt, sau đó tính trung bình các chỉ số tài chính quan trọng — tạo ra bảng so sánh chuẩn để Power BI vẽ biểu đồ phân tích yếu tố rủi ro.*

---

## 8. Key Insights

### 💰 Thu nhập là yếu tố phân biệt mạnh nhất — không phải Credit Score
Nhóm Approved có thu nhập trung bình $102,211, gấp hơn 2 lần nhóm Declined ($45,641). Trong khi đó, chênh lệch Credit Score chỉ là ~17 điểm (584 vs 568) — không đủ để giải thích sự khác biệt lớn về tỷ lệ phê duyệt. Điều này gợi ý rằng mô hình phê duyệt đang ưu tiên khả năng trả nợ (income-based) hơn là lịch sử tín dụng.

### 📉 DTI giống nhau giữa 2 nhóm — yếu tố này không phải driver chính
Cả Approved và Declined đều có Avg DTI = 28.57% — hoàn toàn không có sự khác biệt. Đây là phát hiện đáng chú ý: DTI thường được coi là chỉ số quan trọng trong thẩm định tín dụng, nhưng trong dataset này nó không phân biệt được 2 nhóm.

### 📊 Tỷ lệ phê duyệt dao động mạnh qua các năm nhưng không có xu hướng rõ ràng
Approval Rate biến động từ mức thấp nhất ~19% đến cao nhất ~31% (đỉnh năm 2055), với YoY Change trung bình chỉ -0.02%. Không có trend tăng hoặc giảm bền vững — cho thấy chính sách tín dụng thay đổi theo chu kỳ hoặc phụ thuộc vào điều kiện kinh tế vĩ mô từng giai đoạn.

### 🏆 Ngay cả nhóm Excellent Credit (622+) vẫn bị từ chối nhiều hơn được duyệt
Tier 1-2 (Excellent, 622+) có 1,100 Approved nhưng tới 2,000 Declined — tỷ lệ phê duyệt chỉ khoảng 35% dù credit score cao nhất. Điều này xác nhận rằng credit score không phải yếu tố quyết định duy nhất — thu nhập và các chỉ số tài sản đóng vai trò lớn hơn nhiều.

### 📉 Tỷ lệ từ chối cực cao (76.1%) cho thấy bộ tiêu chí thẩm định rất chặt
Với 15,200/20,000 hồ sơ bị Declined, ngân hàng đang áp dụng tiêu chuẩn phê duyệt rất khắt khe. Cần đánh giá thêm liệu tỷ lệ này có đang loại bỏ các hồ sơ tốt tiềm năng (false negatives) hay không — đặc biệt ở nhóm có thu nhập thấp nhưng lịch sử thanh toán tốt.

---

## 9. Recommendations

**1. Xem xét lại trọng số của thu nhập trong mô hình phê duyệt**
Chênh lệch thu nhập $56K giữa 2 nhóm cho thấy income đang chiếm vai trò áp đảo. Đội Risk Management nên kiểm tra xem mô hình có đang bỏ qua các tín hiệu tích cực khác (payment history, savings balance) không — để tránh loại bỏ những người vay tiềm năng tốt có thu nhập thấp hơn mức trung bình.

**2. Điều tra lý do DTI không phân biệt được 2 nhóm**
DTI bằng nhau hoàn toàn giữa Approved và Declined là bất thường. Đội Data cần kiểm tra lại cách tính `TotalDebtToIncomeRatio` trong dataset — có thể có vấn đề về data quality hoặc cách định nghĩa metric này.

**3. Xây dựng chính sách riêng cho từng Credit Tier**
Thay vì áp dụng một ngưỡng phê duyệt chung, xem xét thiết lập tiêu chí riêng theo Tier — ví dụ Tier 1-2 (Excellent) có thể được nới lỏng yêu cầu thu nhập tối thiểu, trong khi Tier 7-8 (High Risk) cần yêu cầu tài sản đảm bảo cao hơn. [Đội Credit Policy]

**4. Phân tích sâu các năm có Approval Rate đột biến**
Năm 2055 có Approval Rate cao nhất (~31%) và một số năm xuống dưới 20% — cần tìm hiểu nguyên nhân (thay đổi chính sách? điều kiện thị trường?) để rút ra bài học cho chu kỳ tiếp theo. [Đội Strategy]

---

## 10. Assumptions & Limitations

**Assumptions:**
- Dataset là synthetic (dữ liệu giả lập) — các pattern có thể không phản ánh hoàn toàn thực tế thị trường tín dụng
- `LoanApproved = 1` được coi là Approved, `= 0` là Declined — không có trạng thái trung gian (pending, withdrawn)
- Thời gian dữ liệu trải dài đến 2072 — đây là dữ liệu mô phỏng, không phải dự báo thực

**Limitations:**
- Chỉ có 1 bảng — không có thông tin về kết quả thực tế sau khi vay (có trả được không, có bị default không)
- DTI không phân biệt được 2 nhóm → cần điều tra thêm trước khi kết luận về vai trò của chỉ số này
- Không có thông tin địa lý (tiểu bang, quốc gia) để phân tích theo khu vực
- SQL query chỉ tính average — không capture được phân phối (distribution) thực sự của các biến

---

## 11. Future Enhancements

- Xây dựng mô hình Machine Learning (Logistic Regression / Random Forest) để dự đoán Loan Approval dựa trên 36 features
- Phân tích feature importance để xác định chính xác trọng số của từng yếu tố trong quyết định phê duyệt
- Thêm phân tích phân phối (histogram, boxplot) cho Income và Credit Score theo từng Tier

---

## 12. Deliverables

- ✅ `queries/loan_analysis.sql` — SQL query phân tích theo năm và approval status
- ✅ `data/Loan.csv` — Dataset gốc 20,000 records, 36 columns
- ✅ `reports/Drivers_of_financial_risk.pdf` — Export dashboard Power BI (3 trang)
- ✅ `README.md` — Tài liệu project đầy đủ

---

## 13. Author

**Phan Ngoc Kim Thoa**
- 📧 thoaphan2921@gmail.com
- 💼 [LinkedIn](https://www.linkedin.com/in/thoangoc2906)
- 🐙 [GitHub](https://github.com/thoangoc2921)
