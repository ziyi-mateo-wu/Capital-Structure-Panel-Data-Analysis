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

#Create new variables - financing deficit (p7p8p9p) and net debt issued (bp7p) in the financial year
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
#than they reduced). The median value is -B#0.05 million which is close to zero showing that more than half of the firms
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
#p7p = p=0 + p=1p7p8p9p + p