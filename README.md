# Capital Structure Determinants: A Panel Data Analysis 📊

> A rigorous econometric study on US mid-cap firms (2014-2023), utilizing **Fixed Effects Panel Models** to test the validity of the Pecking Order (PO) Theory against the Trade-off Theory.

[![Status](https://img.shields.io/badge/Result-Partial%20Support-yellow?style=for-the-badge)](https://github.com/ziyi-mateo-wu)
[![Language](https://img.shields.io/badge/R-plm%20%7C%20Tidyverse-blue?style=for-the-badge&logo=r)](https://www.r-project.org/)
[![Method](https://img.shields.io/badge/Econometrics-Fixed%20Effects%20%26%20Robust%20Inference-orange?style=for-the-badge)](https://github.com/ziyi-mateo-wu)

### 📌 Project Context
**Research Question:** Does the **Pecking Order (PO) Theory** hold for modern US firms in a high-interest rate environment?

The theory posits a strict hierarchy: **Internal Funds > Debt > Equity**. Specifically, the "Strict PO" hypothesis predicts that for every $1 of financing deficit, a firm should issue exactly $1 of debt ($\beta = 1$).

This project empirically tests this hypothesis using a longitudinal dataset of **726 medium-sized US firms** (sourced from WRDS), applying advanced panel data techniques to control for unobserved heterogeneity.

---

### 🏗️ Econometric Framework

Unlike simple cross-sectional regression, this study utilizes a **One-Way Fixed Effects (Within) Model** to eliminate time-invariant firm characteristics (e.g., corporate culture, industry risk):

$$\Delta D_{it} = \alpha_i + \beta_1 DEF_{it} + \beta_X X_{it} + \epsilon_{it}$$

* **Dependent Variable ($\Delta D_{it}$):** Net Debt Issued.
* **Key Regressor ($DEF_{it}$):** Financing Deficit.
* **$\alpha_i$:** Firm-specific fixed effects (capturing unobserved heterogeneity).
* **Robust Inference:** Standard errors are clustered at the firm level to correct for heteroskedasticity and serial correlation.

---

### 📊 Key Empirical Findings

The analysis produced statistically significant results that challenge the "Strict" Pecking Order theory while supporting its general direction.

#### 1. The "25 Cent" Reality (Fixed Effects Coefficient)
* **Result:** The coefficient for Financing Deficit ($\beta_1$) is estimated at **0.255** ($p < 0.05$ with robust errors).
* **Interpretation:** For every $1 million increase in financing deficit, firms issue approximately **$0.255 million** in net debt, relying more on equity or cash reserves than the theory predicts.
* **Conclusion:** The hypothesis of $\beta = 1$ is rejected, suggesting a "Modified Pecking Order" behavior.

#### 2. Robustness & Model Selection
* **Hausman Test:** The test yielded a p-value > 0.05, but Fixed Effects was retained for theoretical consistency (controlling for unobserved bias).
* **Robust Standard Errors:** After applying Clustered Robust Standard Errors (HC1), the significance of the deficit coefficient remained valid, confirming that the results are not driven by heteroskedasticity.

---

### 📉 Visualizations & Diagnostics

#### 1. Correlation Analysis
The scatterplot reveals a positive correlation ($\rho \approx 0.48$) between financing needs and debt issuance, providing preliminary support for the theory before controlling for fixed effects.

<img width="749" height="475" alt="Correlation Plot" src="https://github.com/user-attachments/assets/8e9fc4c9-773c-42f7-a4ec-7b34e44e23bd" />

#### 2. Model Specification (R Output)
The table below highlights the significant impact of the financing deficit even after controlling for other capital structure determinants.

*(Note: Initial OLS exploratory results shown below; see code for final Fixed Effects output)*
<img width="933" height="907" alt="Regression Table" src="https://github.com/user-attachments/assets/be68f051-216f-4338-85a8-cead2c3b6a20" />

---

### 💻 Tech Stack & Replication Code

This project goes beyond basic regression by implementing **Panel Data Econometrics** in R.

* **Core Libraries:** `plm` (Panel Data), `lmtest` (Hypothesis Testing), `sandwich` (Robust Covariance Matrix).
* **Advanced Diagnostics:** Hausman Test, Heteroskedasticity-Consistent (HC) Standard Errors.

**Snippet: Fixed Effects & Robust Inference**
```r
# 1. Panel Data Transformation
p_data <- pdata.frame(medfirmdata, index = c("gvkey", "fyear"))

# 2. Fixed Effects Model Estimation
fe_model <- plm(netDebtIssued ~ financingDeficit, data = p_data, model = "within")

# 3. Robust Inference (Clustered Standard Errors)
# Correcting for heteroskedasticity/autocorrelation
coeftest(fe_model, vcov = vcovHC(fe_model, type = "HC1", cluster = "group"))
