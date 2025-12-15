# Corporate Capital Structure: Testing the Pecking Order Theory 📊

> An econometric analysis of financing behavior in medium-sized US firms (2014-2023), utilizing **Panel Data** to test the validity of the Pecking Order (PO) Theory.

[![Status](https://img.shields.io/badge/Result-Partial%20Support-yellow?style=for-the-badge)](https://github.com/ziyi-mateo-wu)
[![Language](https://img.shields.io/badge/R-Tidyverse%20%7C%20ggplot2-blue?style=for-the-badge&logo=r)](https://www.r-project.org/)
[![Method](https://img.shields.io/badge/Econometrics-Regression%20Analysis-orange?style=for-the-badge)](https://github.com/ziyi-mateo-wu)

### 📌 Project Context
Does the **Pecking Order (PO) Theory** hold for modern US firms?
The theory posits a strict hierarchy: firms prefer **Internal Funds > Debt > Equity**. Specifically, it predicts that for every $1 of financing deficit, a firm should issue $1 of debt ($\beta = 1$).

This project empirically tests this hypothesis using a dataset of **726 medium-sized US firms** sourced from **WRDS**, analyzing the relationship between **Financing Deficit** and **Net Debt Issuance**.

---

### 🏗️ Econometric Framework

The study utilizes a **Multivariate Regression Model** on panel data structure:

$$\Delta D_i = \beta_0 + \beta_1 DEF_i + \beta_2 \Delta T_i + \beta_3 \Delta MTB_i + \beta_4 \Delta LS_i + \beta_5 \Delta P_i + \epsilon_i$$

* **Dependent Variable ($\Delta D_i$):** Net Debt Issued.
* **Key Independent Variable ($DEF_i$):** Financing Deficit.
* **Controls:** Asset Tangibility ($T$), Market-to-Book Ratio ($MTB$), Log Sales ($LS$), Profitability ($P$).
* **Core Hypothesis Test:** $H_0: \beta_1 = 1$ (Strict Pecking Order).

---

### 📊 Key Empirical Findings

The regression analysis produced statistically significant but nuanced results, challenging the strict interpretation of the theory.

#### 1. The "27 Cent" Reality (Coefficient Analysis)
* **Result:** The coefficient for Financing Deficit ($\beta_1$) was estimated at **0.275** ($p < 2e^{-16}$).
* **Interpretation:** For every $1 million increase in financing deficit, firms only issue **$0.275 million** in net debt.
* **Conclusion:** While the positive relationship supports the *direction* of the PO theory, the magnitude significantly violates the "dollar-for-dollar" prediction ($\beta_1 \neq 1$).

#### 2. Model Performance (Goodness of Fit)
* **$R^2$ of 0.228:** The financing deficit alone explains **22.8%** of the variation in debt issuance.
* **Control Variables:** Interestingly, adding firm-level controls (Tangibility, Profitability, etc.) in the multivariate model **did not significantly improve** the adjusted $R^2$, suggesting that the Financing Deficit is indeed the dominant driver of leverage decisions.

---

### 📄 Full Research Paper

For a detailed discussion on Information Asymmetry, Adverse Selection, and the complete regression diagnostics, please refer to the full report.

[![Read Full Report](https://img.shields.io/badge/Read%20Full%20Paper-PDF-red?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](Pecking_Order_Theory_Report.pdf)

---

### 📉 Empirical Evidence & Diagnostics

The following visualizations document the relationship between deficits and debt issuance.

#### 1. Correlation Analysis: Debt vs. Deficit
**Visualization:** The scatterplot reveals a clear positive linear relationship (Red Line), consistent with the hypothesis that firms cover deficits with debt. However, the dispersion (Blue Points) indicates significant heterogeneity in firm behavior not captured by the simple model.

<img width="100%" alt="Net Debt vs Deficit Scatterplot" src="01_scatter_plot.png" />

<br>

#### 2. Regression Model Comparison (Univariate vs. Multivariate)
**Evidence:** The regression table confirms that while the Deficit coefficient ($0.275^{***}$) is highly significant, other factors like **Change in Profitability** and **Tangibility** are statistically insignificant, reinforcing the prominence of the deficit in capital structure decisions.

<img width="100%" alt="Regression Table" src="02_regression_table.png" />

---

### 💻 Tech Stack & Replication

* **Language:** R
* **Key Libraries:** `ggplot2` (Visualization), `stats` (Regression), `plm` (Panel Data Structures).
* **Data Source:** Wharton Research Data Services (WRDS).

To replicate the findings, ensure the dataset `mediumfirm.xlsx` (or converted CSV) is in the root directory and run the regression script.
