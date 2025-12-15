#Downloading and attaching necessary packages
install.packages("tidyverse")
library(tidyverse)
install.packages("readxl")
library(readxl)
install.packages("ggrepel")
library(ggrepel)

#importing medium firm data set
medfirmdata <- read_xlsx("mediumfirm.xlsx")
head(medfirmdata)

#a)

#Create new variables - financing deficit (𝐷𝐸𝐹𝑖) and net debt issued (∆𝐷𝑖) in the financial year
medfirmdata <- medfirmdata %>%
  mutate(
    financingDeficit = div + invest + wcap_delta - cashflow, 
    netDebtIssued = Dissue - Dreduce
  )
head(medfirmdata)

summary(medfirmdata)

#financingDeficit summary statistics (mean, median and standard deviation)
mean(medfirmdata$financingDeficit)
#9.888474
median(medfirmdata$financingDeficit)
#3.6075
sd(medfirmdata$financingDeficit)
# 25.96407
##comments - The average financing deficit of all firms in the data set is $9.89 million. The median value for
#financing deficit is $3.61 million which is much lower indicating that the data is right-skewed (there are a few firms
# with very large financing deficits that is pulling the mean higher). The standard deviation of $25.96 million is
#quite large relative to the mean and median, indicating that there is significant variability in the financing deficit
#across firms showing that firms are in very different financial situations regarding their financing needs.

#netDebtIssued summary statistics (mean, median and standard deviation)
mean(medfirmdata$netDebtIssued)
#2.828737
median(medfirmdata$netDebtIssued)
#-0.052
sd(medfirmdata$netDebtIssued)
#14.97781
##comments - The average net debt issued across all firms in the data set is $2.83 million (more firms on average have issued more debt
#than they reduced). The median value is -£0.05 million which is close to zero showing that more than half of the firms
#in the data set have issued less debt than they have reduced. This shows that not all firms are actively increasing 
#their leverage and instead many are focusing on reducing or managing their existing debt load. Moreover, the standard
#deviation of $14.98 million is relatively high compared to both the mean and median indicating significant variability in 
#the amount of debt issued by firms.

##Overall Comments - The results above reflect the Pecking Order Theory as while many firms have a financing deficit 
#they are not aggressively issuing new debt. Low median for net debt issuance suggests that firms are able to rely on
#internal financing or equity issuance for their capital needs rather than leaning heavily on debt. The positive mean
#financing deficit indicates that firms still face some need for external capital. Both financing deficit and net debt
#issued have high standard deviation showing diverse firm behaviour e.g. the specific financial position and industry
#firms operate in could impact each firm's capital structure decisions.

#b)

#scatter plot for net debt issued in relation to financial deficit
ggplot(medfirmdata, aes(y=netDebtIssued, x=financingDeficit)) +
                geom_smooth(method = "lm", se= F , col = "red")+
                geom_point(col = "blue" , size=2)+
                xlab("Financial deficit (USD, in millions)")+
                ylab("Net debt issued (USD, in millions)")+
                ggtitle("Net Debt Issued vs Financial Deficit")

#correlation coefficient
cor(medfirmdata$financingDeficit, medfirmdata$netDebtIssued)
#0.4775165
#The correlation coefficient is about 48% which indicates moderate positive correlation 

#Does the relationship seem broadly linear?
#Yes, the points appear to form a consistent upward trend although there is outliers.

#c)
#The PO theory suggests that for a firm in normal operations, financing deficit will match net debt issued
# Estimate the regression model,
#𝐷𝑖 = 𝛽0 + 𝛽1𝐷𝐸𝐹𝑖 + 𝜀𝑖 
#Interpret the estimated parameters and comment on the model’s explanatory power

#regression model to test if financing deficit matches net debt issued
regModel <- lm(netDebtIssued ~ financingDeficit, data=medfirmdata)
summary(regModel)

#Intercept
intercept<- regModel$coeff[1]
intercept
#0.1048252 
#When the financial deficit is zero the model predicts that the net debt issued will be approximately  
#$0.105 million. P value is 0.841 which is not statistically significant - intercept is not statistically
#different from zero (might not provide much insight into practical implications)

#Slope
slope<-regModel$coeff[2]
slope
# 0.2754633 
#For every $1 million increase in financial deficit, the net debt is expected to 
#increase by $0.275 million. P-value for the slope is <2e-16 which is highly significant - statistically strong
#relationship between financial deficit and net debt issued.

#R-squared - explanatory power of the model
medfirmdata <- medfirmdata %>%
  mutate(resid =residuals(regModel),
         yhat = fitted.values(regModel))

RSS <- sum(medfirmdata$resid^2)
RSS
# 125556.5

TSS <- sum((medfirmdata$netDebtIssued - mean(medfirmdata$netDebtIssued))^2)
TSS
#162642.7

ESS <- TSS-RSS
ESS
#37086.11

rsq <- 1- (RSS/TSS)
rsq
#0.228022

#Explanatory power of the model(R-Squared)=0.228 - Approximately 22.8% of the variability in net debt issued is 
#explained by the financial deficit. This shows a moderate fit but a significant portion (around 77.7%)of the 
# variability in net debt issued is unexplained by the financial deficit alone - other factors not included in 
#the model likely affect the amount of debt firms issue eg firm-specific factors, industry conditions, macroeconomic
#variables or financing preferences.

#Residual standard error = 13.17 on 724 degrees of freedom - On average the net debt issued deviates from the 
#predicted value by $13.17 million. This is quite large compared to the range of debt issued values - indicates 
#that the model could be improved to better explain the variability in debt issuance.

#d)
#The PO implies that financing deficit should match dollar-for-dollar by a change in corporate debt

#Ho: 𝛽0 = 0 Ha: 𝛽0 is not =0 
regModel <- lm(netDebtIssued ~ financingDeficit, data=medfirmdata)
summary(regModel)
pval_intercept <- coef(summary(regModel))[1, "Pr(>|t|)"]
pval_intercept
# 0.8412111
if (pval_intercept < 0.05) {
  cat("Reject H0: β0 = 0. The intercept is significantly different from zero.\n")
} else {
  cat("Fail to reject H0: β0 = 0. There is no strong evidence that the intercept differs from zero.\n")
}

#Fail to reject H0: β0 = 0. There is no strong evidence that the intercept differs from zero.
#Practically this suggests that when firms have no financing deficit they do not systematically issue or reduce debt
#this is consistent with PO theory which implies firms generally don't issue debt unless there is a financing deficit.


#Install car package
install.packages("car")
library(car)

#𝐻0: 𝛽1 = 1 𝐻a: 𝛽1 is not = 1 
test1 <- linearHypothesis(regModel, c("financingDeficit=1"))
test1
# p value = 2.2e-16 
# p value < 0.05 therefore we can reject Ho
#This suggests that B1 is significantly different from 1 
#The relationship between the financing deficit and the net debt issued does not match a dollar for dollar change


#Jointly
#𝐻0: 𝛽0 = 0 and 𝐻0: 𝛽1 = 1. 
#𝐻a: 𝛽0 is not =0 or𝐻a: 𝛽1 is not =1
joint_test <- linearHypothesis(regModel, c("(Intercept) = 0", "financingDeficit = 1"))
print(joint_test)

# p value =  2.2e-16 
#p value <0.05 therefore null is rejected.
#it suggests that both assumptions (β0 = 0 and β1 = 1) are violated, meaning firms deviate from PO theory.


#e)
#Frank and Goyal (2003) extended the empirical test by incorporating financing deficit as
#an explanatory variable in a set of four conventional explanatory variables of corporate
#capital structure. Estimate the multivariate regression model,
#∆𝐷𝑖 = 𝛽0 + 𝛽1𝐷𝐸𝐹𝑖 + 𝛽2∆𝑇𝑖 + 𝛽3∆𝑀𝑇𝐵𝑖 + 𝛽4∆𝐿𝑆𝑖 + 𝛽5∆𝑃𝑖 + 𝑢𝑖 


multiRegModel <- lm(netDebtIssued ~ financingDeficit + tang_delta + mtb_delta + lsale_delta + profit_delta, data=medfirmdata)
#Print results of model
summary(multiRegModel)

summary_Multi<- summary(multiRegModel)

#coefficient and p-value for each variable
coeffs<- summary_Multi$coefficients[,1]
pvalues<- summary_Multi$coefficients[,4]

#Interpret results to see if align with PO theory and check significance
interpret_variable <- function(var_name, expected_sign) {
  coef_value <- coeffs[var_name]
  pvalue <- pvalues[var_name]
  
  if ((expected_sign == "positive" && coef_value > 0) || (expected_sign == "negative" && coef_value < 0)) {
    signcorrect <- "correct"
  } else {
    signcorrect <- "incorrect"
  }
  
  significance <- ifelse(pvalue < 0.05, "statistically significant", "statistically insignificant")
  
  cat(paste("\n", var_name, ":", coef_value, 
            "- Sign is", signcorrect, 
            "and result is", significance, "\n"))
}

#Interpret each variable with reference to theoretical predictions and statistical significance
interpret_variable("financingDeficit", "positive")
interpret_variable("tang_delta", "positive") 
interpret_variable("mtb_delta", "negative")
interpret_variable("lsale_delta", "positive") 
interpret_variable("profit_delta", "negative")

# financingDeficit : 0.274790846849825 - Sign is correct and result is statistically significant
# p value = <2e-16 which is less than 0.05
#Supports Po theory 


#tang_delta : 4.31800201116597 - Sign is correct and result is statistically insignificant
# p value =  0.419 which is greater than 0.05
#Supports PO theory B2>0 but not significant

#mtb_delta : -0.0784637773129717 - Sign is correct and result is statistically insignificant
#p-value = 0.522 which is greater than 0.05
#Supports PO theory B3<0 but not significant

# lsale_delta : 0.138554886815737 - Sign is correct and result is statistically insignificant
#p value = 0.810 which is greater than 0.05
#Supports PO theory B4>0 but not significant

# profit_delta : 0.485853660743415 - Sign is incorrect and result is statistically insignificant 
#p-value = 0.757 which is greater than 0.05
#Doesn't support PO theory B3<0 and not significant



#f)
#compare Model 1 and Model 2 


anova_result <- anova(regModel, multiRegModel)
print(anova_result)

p_value_f_test <- anova_result$"Pr(>F)"[2]
cat("\nP-value for F-test:", round(p_value_f_test, 5), "\n")

if (p_value_f_test < 0.05) {
  cat("Model (2) is statistically better than Model (1) at explaining debt issuance.\n")
} else {
  cat("No significant improvement from Model (1) to Model (2).\n")
}

#No significant improvement from Model (1) to Model (2).

install.packages("stargazer")
library(stargazer)

stargazer(regModel, multiRegModel, 
          type = "html",
          out = "Regression_model_comparison.html",
          no.space = TRUE,
          covariate.labels = c("Financing Deficit", "Change in Tangibility", 
                               "Change in Market-to-Book Ratio", "Change in Log Sales", 
                               "Change in Profitability"),
          dep.var.labels = c("Net Debt Issued"),
          column.labels = c("Univariate Model", "Multivariate Model"),
          style = "default", 
          title = "Regression Model Comparison")

#R-squared
#Model 1 = 0.228
#model 2 = 0.2295
#The univariate model already explains a significant portion of the variance in net debt issued but r-squared
#increases slightly in model 2 

#Adjusted R-squared
#Model 1 = 0.227 
#Model 2 = 0.2242
#Model 2 has not got a higher adjusted R-squared suggesting that the additional predictors do not improve model fit

#F-statistic
#Model 1 = 213.9 
#Model 2 =  42.9
#Model 1 is much higher than Model 2 indicating that the single explanatory variable (financing deficit) has strong 
#predictive power on its own.


          
















  




