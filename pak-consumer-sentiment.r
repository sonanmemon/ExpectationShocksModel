library(dslabs)
library(dplyr)
library(ggplot2)
options(stringsAsFactors = FALSE)
library(tidyverse)
library(gridExtra)
library(Lahman)
library(AER)
library(tseries)
library(dynlm)
library(stargazer)
library(forecast)
library(mFilter)
library(data.table)
library(caTools)
library(scales)
library(hrbrthemes)
ds_theme_set()
library(tikzDevice)
require(tikzDevice)




pos_neg <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/pos-neg.csv")


overall_indices <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/overall-indices.csv")


BCI <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/businessconfidenceindex.csv")


q_wise_indices <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/q-wise-indices.csv")

inflation_expect_sixmonths <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/inflation-expect-6months.csv")

unemp_interestrate_expect <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/unemployment_interestrate.csv")

quarterlygdp_2012to2021 <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/quarterlygdppak_2012to2021.csv")

quarterlygdp_1979to2021 <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/quarterlygdp_pakistan1978to2021.csv")

overall_indices_quarterly <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/Consumer Sentiments and Business Cycles/Data on Consumer Confidence SBP/overall-indices-quarterly.csv")





overall_indices <- ts(overall_indices, start = c(2012,1), frequency = 6)


overall_indices <- data.frame(overall_indices)

head(overall_indices)

overall_indices$DATE <- seq(from = as.Date("2012-01-01"), to = as.Date("2022-09-01"), by = "2 months")


overall_indices


overall_indices <- overall_indices[,-1]

overall_indices




BCI <- ts(BCI, start = c(2017,10), frequency = 6)

BCI <- data.frame(BCI)

head(BCI)

BCI$DATE <- seq(from = as.Date("2017-10-01"), to = as.Date("2022-08-01"), by = "2 months")


BCI <- BCI[,-1]



colnames(BCI) <- c("economicconditionspast6months", 
                   "expectedeconomicconditions6months", 
                   "expectedexchangerate6months", 
                   "expectedinflation6months",
                   "DATE")




BCI

colors <- c("EEC" = "red", "EER" = "green",
"EI" = "blue")

tikz(file = "BCI.tex", width = 6, height = 3.7)

graph <- ggplot(BCI) +
  geom_line(aes(x=DATE, y=expectedeconomicconditions6months, color = "EEC"), size = 1) +
  geom_line(aes(x=DATE, y= expectedexchangerate6months, color = "EER"), size = 1) +
  geom_line(aes(x=DATE, y=expectedinflation6months, color = "EI"), size = 1) +
  #geom_hline(yintercept=mean(overall_indices$CCI), linetype="dashed", color = "black") +
  scale_y_continuous(breaks = c(30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80)) +
  scale_x_date(breaks = scales::date_breaks("4 months"), date_labels = "%Y-%m") +
  #scale_x_date(date_labels = "%Y-%m-%d") +
  labs(x = "Time", y = "Index", title = "Business Confidence in Pakistan", color = "Legend") +
  scale_color_manual(values = colors) +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))






#This line is only necessary if you want to preview the plot right after compiling
print(graph)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()

BCI

BCI_2021cut <- BCI[1:24,]

BCI_2021cut




quarterlygdp_2017to2021 <- quarterlygdp_2012to2021[24:39, ]





BCI_centered_roll_mean <- runmean(BCI_2021cut[,2], 9, alg=c("fast"), endrule=c("NA"), align = c("center"))


BCI_centered_roll_mean

quarterlygdp_2017to2021$BCI = BCI_centered_roll_mean[5:20]

quarterlygdp_2017to2021$logBCI <- log10(quarterlygdp_2017to2021$BCI)

quarterlygdp_2017to2021$GBCI <- NA





for(x in 2:16){
  quarterlygdp_2017to2021$GBCI[x] = ((quarterlygdp_2017to2021$BCI[x] - quarterlygdp_2017to2021$BCI[x-1])/quarterlygdp_2017to2021$BCI[x-1]) * 100
}


quarterlygdp_2017to2021



ccf(quarterlygdp_2017to2021$real_gdp_gr, quarterlygdp_2017to2021$GBCI[-1])





quarterlygdp_2017to2021 <- data.frame(quarterlygdp_2017to2021)

head(quarterlygdp_2017to2021)

df <- quarterlygdp_2017to2021

df_x <- eval(substitute(df$real_gdp_gr),df)
df_y <- eval(substitute(df$GBCI[-1]),df)
ccf.object <- ccf(df_x,df_y,plot=FALSE, lag=5)
output_table <- cbind(lag=ccf.object$lag, x.corr=ccf.object$acf) %>% as_tibble() %>% mutate(cat=ifelse(x.corr>0,"green","red"))
output_table %>% ggplot(aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=cat))+scale_fill_manual(values=c("#339933","#cc0000"))+ylab("Cross correlation")+scale_y_continuous(limits=c(-1,1))+theme_bw()+theme(legend.position = "none", plot.title=element_text(size=10))+ggtitle(title) -> p


tikz(file = "BCI_GrowthGDP.tex", width = 6, height = 3.7)






BCI_growthGDP <- ggplot(output_table, aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=cat))+scale_fill_manual(values=c("#339933","#cc0000"))+ geom_hline(yintercept=0.31) + geom_hline(yintercept = -0.31) + 
  ggtitle("Growth in Business Confidence Index and Real GDP") + ylab("Cross Correlation") + xlab("Lag Order") +
  scale_x_continuous(breaks = c(-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5)) +
  scale_y_continuous(limits=c(-1,1)) +
  theme_bw()+
  theme(legend.position = "none", plot.title=element_text(hjust = 0.5))
  #theme(plot.title = element_text(hjust = 0.5))

print(BCI_growthGDP)


#Necessary to close or the tikxDevice .tex file will not be written
dev.off()









colors <- c("CCI" = "red", "CEC" = "green", "EEC" = "blue")

tikz(file = "CC_Pakistan.tex", width = 6, height = 3.7)

graph <- ggplot(overall_indices) +
  geom_line(aes(x=DATE, y=CCI, color = "CCI"), size = 1) +
  geom_line(aes(x=DATE, y=CEC, color = "CEC"), size = 1) +
  geom_line(aes(x=DATE, y=EEC, color = "EEC"), size = 1) +
  #geom_hline(yintercept=mean(overall_indices$CCI), linetype="dashed", color = "black") +
  scale_y_continuous(breaks = c(30, 35, 40, 45, 50, 55, 60)) +
  scale_x_date(breaks = scales::date_breaks("10 months"), date_labels = "%Y-%m") +
  #scale_x_date(date_labels = "%Y-%m-%d") +
  labs(x = "Time", y = "Index", title = "Evolution of Consumer Confidence in Pakistan", color = "Legend") +
  scale_color_manual(values = colors) +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))
  
  




#This line is only necessary if you want to preview the plot right after compiling
print(graph)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()








q_wise_indices <- ts(q_wise_indices, start = c(2012,1), frequency = 6)


q_wise_indices <- data.frame(q_wise_indices)



q_wise_indices$DATE <- seq(from = as.Date("2012-01-01"), to = as.Date("2021-05-01"), by = "2 months")




#colnames(data) <- c("GDP", "NX", "time_index", "DATE")



inflation_expect_sixmonths <- ts(inflation_expect_sixmonths, start = c(2012,1), frequency = 6)


inflation_expect_sixmonths <- data.frame(inflation_expect_sixmonths)



inflation_expect_sixmonths$DATE <- seq(from = as.Date("2012-01-01"), to = as.Date("2021-05-01"), by = "2 months")




inflation_expect_sixmonths <- inflation_expect_sixmonths %>% gather(key = Category, value = Value, dailyuse, food, energy, non.food)   
     
     


     

tikz(file = "InflationExpectations.tex", width = 6, height = 3.7)








inflation_expectplot <- ggplot(inflation_expect_sixmonths) +
  geom_line(aes(x = DATE, y = Value, color = Category, group = Category), size = 1) +
  scale_y_continuous(breaks = c(55, 60, 65, 70, 75, 80)) +
  scale_x_date(breaks = scales::date_breaks("10 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Index", title = "Six Month Ahead Inflation Expectations", color ="Legend") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))


print(inflation_expectplot)
dev.off()


durables_housing <- q_wise_indices[, c("DATE", "Next.six.months.for.purchasing.durable.household.items", "Next.six.months.for.purchasing.automobile..car.motorcycle.", "Current.times.for.purchase.or.construction.of.new.house")]




colnames(durables_housing) <- c("DATE", "durables", "automobiles", "house")

head(durables_housing)




durables_housing <- durables_housing %>% gather(key = Category, value = Value, durables, automobiles, house) 






tikz(file = "CC_Durables.tex", width = 6, height = 3.7)












durables_housingplot <- ggplot(durables_housing) +
  geom_line(aes(x = DATE, y = Value, color = Category, group = Category), size = 1) +
  scale_y_continuous(breaks = c(30, 35, 40, 45, 50)) +
  scale_x_date(breaks = scales::date_breaks("12 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Index", title = "Consumer Confidence Regarding Durables", color = "Legend") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))



print(durables_housingplot)
dev.off()





unemp_interestrate_expect <- ts(unemp_interestrate_expect, start = c(2012,1), frequency = 6)


unemp_interestrate_expect <- data.frame(unemp_interestrate_expect)



unemp_interestrate_expect$DATE <- seq(from = as.Date("2012-01-01"), to = as.Date("2021-05-01"), by = "2 months")

colnames(unemp_interestrate_expect) <- c("unemployment", "Interest Rate", "DATE")


unemp_interestrate_expect <- unemp_interestrate_expect %>% gather(key = Variable, value = Value, unemployment, `Interest Rate`)


tikz(file = "Unemployment_Interest.tex", width = 6, height = 3.7)





unemp_interestrate_plot <- ggplot(unemp_interestrate_expect) +
  geom_line(aes(x = DATE, y = Value, color = Variable, group = Variable), size = 1) +
  scale_y_continuous(breaks = c(50, 55, 60, 65, 70, 75)) +
  scale_x_date(breaks = scales::date_breaks("11 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Index", title = " Unemployment and Interest Rate Expectations", color = "Legend") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))


print(unemp_interestrate_plot)
dev.off()











quarterlygdp_2012to2021 <- ts(quarterlygdp_2012to2021, start = c(2012,1), frequency = 4)


quarterlygdp_2012to2021 <- data.frame(quarterlygdp_2012to2021)



quarterlygdp_2012to2021$DATE <- seq(from = as.Date("2012-01-01"), to = as.Date("2021-07-01"), by = "quarter")




head(quarterlygdp_2012to2021)


tikz(file = "GDP_2012to2021.tex", width = 6, height = 3.7)






quarterlygdp_plot <- ggplot(quarterlygdp_2012to2021) +
  geom_line(aes(x = DATE, y = real_gdp_gr), color = "purple", size = 1.5) +
  scale_y_continuous(breaks = c(-1, 0, 1, 2, 3, 4, 5, 6, 7)) +
  scale_x_date(breaks = scales::date_breaks("7 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Growth Rate", title = "Real GDP Growth") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))


print(quarterlygdp_plot)
dev.off()





quarterlygdp_1979to2021 <- ts(quarterlygdp_1979to2021, start = c(1979,1), frequency = 4)


quarterlygdp_1979to2021 <- data.frame(quarterlygdp_1979to2021)



quarterlygdp_1979to2021$DATE <- seq(from = as.Date("1979-01-01"), to = as.Date("2021-07-01"), by = "quarter")



quarterlygdp_1979to2021 <- quarterlygdp_1979to2021[, -2]


head(quarterlygdp_1979to2021)


tikz(file = "GDP_1979-2021.tex", width = 6, height = 3.7)




quarterlygdp_plot2021 <- ggplot(quarterlygdp_1979to2021) +
  geom_line(aes(x = DATE, y = real_gdp_gr), color = "purple", size = 1.5) +
  scale_y_continuous(breaks = c(-1, 0, 2, 4, 6, 8, 10, 12)) +
  scale_x_date(breaks = scales::date_breaks("16 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Growth Rate", title = "Real GDP Growth Rate in Pakistan") +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(# Hide panel borders and remove grid lines
    #panel.border = element_blank(),
    #panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Change axis line
   # axis.line = element_line(colour = "black")
  ) +
  #theme(
    #panel.background = element_rect(fill = "#BFD5E3", colour = "#6D9EC1",
      #                              size = 2, linetype = "solid"),
  #  panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                   # colour = "black")
  #) +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.title = element_text(hjust = 0.5))




#This line is only necessary if you want to preview the plot right after compiling
print(quarterlygdp_plot2021)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()




#growth_centered_roll_mean <- runmean(data[-1,6], 3, alg=c("fast"), endrule=c("NA"), align = c("center"))
#growth_forward_roll_mean <- runmean(data[-1,6], 3, alg=c("fast"), endrule=c("NA"), align = c("left"))
#growth_backward_roll_mean <- runmean(data[-1,6], 3, alg=c("fast"), endrule=c("NA"), align = c("right"))


#CEC_centered_mean <- runmean(overall_indices[, 1], 3, alg=c("fast"), endrule=c("NA"), align = c("center"))





overall_indices_quarterly <- ts(overall_indices_quarterly, start = c(2012,1), frequency = 4)


overall_indices_quarterly <- data.frame(overall_indices_quarterly)



overall_indices_quarterly$DATE <- seq(from = as.Date("2012-01-01"), to = as.Date("2021-04-01"), by = "quarter")


head(overall_indices_quarterly)

colnames(overall_indices_quarterly) <- c("Quarter", "CEC", "CCI", "EEC", "DATE")




overall_indices_quarterlygather <- overall_indices_quarterly %>% gather(key = Series, value = Value, CEC, CCI, EEC)


tikz(file = "CC_Quarterly.tex", width = 6, height = 3.7)








overall_indices_quarterlyplot <- ggplot(overall_indices_quarterlygather) +
  geom_line(aes(x = DATE, y = Value, color = Series, group = Series), size = 1) +
  scale_y_continuous(breaks = c(30, 35, 40, 45, 50, 55)) +
  scale_x_date(breaks = scales::date_breaks("11 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Index", title = "Quarterized Consumer Confidence Indices", color = "Legend") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

print(overall_indices_quarterlyplot)
dev.off()


overall_indices_quarterlyplot


overall_indices_quarterly

#overall_indices_quarterly2018 <- overall_indices_quarterly[1:28, ]
quarterlygdp_2012to2021 <- quarterlygdp_2012to2021[1:38, ]


gdp_consumerconfidence <- cbind(overall_indices_quarterly, quarterlygdp_2012to2021)
gdp_consumerconfidence

gdp_consumerconfidence <- gdp_consumerconfidence[,-1]



gdp_consumerconfidence <- gdp_consumerconfidence[,-7]



gdp_consumerconfidence <- gdp_consumerconfidence[,-5]




















gdp_consumerconfidence$logCCI <- log10(gdp_consumerconfidence$CCI)

gdp_consumerconfidence$logEEC <- log10(gdp_consumerconfidence$EEC)

#adf.test(data$logGDP) # p-value < 0.05 indicates the TS is stationary



diff1_logCCI <- diff(gdp_consumerconfidence$logCCI, differences= 1)


diff1_logEEC <- diff(gdp_consumerconfidence$logEEC, differences= 1)

growth_CCI <- diff1_logCCI*100

growth_EEC <- diff1_logEEC*100




gdp_consumerconfidence[-1, 8] <- diff1_logCCI

gdp_consumerconfidence[-1, 9] <- diff1_logEEC

colnames(gdp_consumerconfidence) <- c("CEC", "CCI", "EEC", "DATE", "real_gdp_gr", "logCCI", "logEEC", "diff1_logCCI", "diff1_logEEC")



gdp_consumerconfidence$growth_CCI <- gdp_consumerconfidence$diff1_logCCI*100
gdp_consumerconfidence$growth_EEC <- gdp_consumerconfidence$diff1_logEEC*100



realgdp_gr <- gdp_consumerconfidence[-1,5]

ccf(growth_CCI, realgdp_gr)

ccf(growth_EEC, realgdp_gr)

CCI_EEC_Growth <- cbind(growth_CCI, growth_EEC, realgdp_gr)

CCI_EEC_Growth <- data.frame(CCI_EEC_Growth)

head(CCI_EEC_Growth)

df <- CCI_EEC_Growth

df_x <- eval(substitute(CCI_EEC_Growth$growth_CCI),df)
df_y <- eval(substitute(CCI_EEC_Growth$realgdp_gr),df)
ccf.object <- ccf(df_x,df_y,plot=FALSE)
output_table <- cbind(lag=ccf.object$lag, x.corr=ccf.object$acf) %>% as_tibble() %>% mutate(cat=ifelse(x.corr>0,"green","red"))
output_table %>% ggplot(aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=cat))+scale_fill_manual(values=c("#339933","#cc0000"))+ylab("Cross correlation")+scale_y_continuous(limits=c(-1,1))+theme_bw()+theme(legend.position = "none", plot.title=element_text(size=10))+ggtitle(title) -> p
ccf_growthCCI_GDP <- ggplot(output_table, aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=cat))+scale_fill_manual(values=c("#339933","#cc0000"))+ geom_hline(yintercept=0.31) + geom_hline(yintercept = -0.31) + ggtitle("Growth in CCI and Real GDP") + ylab("Cross correlation")+
  scale_y_continuous(limits=c(-1,1)) +
  theme_bw()+
  theme(legend.position = "none", plot.title=element_text(size=10))

print(ccf_growthCCI_GDP)




df <- CCI_EEC_Growth

df_x <- eval(substitute(CCI_EEC_Growth$growth_EEC),df)
df_y <- eval(substitute(CCI_EEC_Growth$realgdp_gr),df)
ccf.object <- ccf(df_x,df_y,plot=FALSE)
output_table <- cbind(lag=ccf.object$lag, x.corr=ccf.object$acf) %>% as_tibble() %>% mutate(cat=ifelse(x.corr>0,"green","red"))
output_table %>% ggplot(aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=cat))+scale_fill_manual(values=c("#339933","#cc0000"))+ylab("Cross correlation")+scale_y_continuous(limits=c(-1,1))+theme_bw()+theme(legend.position = "none", plot.title=element_text(size=10))+ggtitle(title) -> p
ccf_growthEEC_GDP <- ggplot(output_table, aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=cat))+scale_fill_manual(values=c("#339933","#cc0000"))+ geom_hline(yintercept=0.31) + geom_hline(yintercept = -0.31) + ggtitle("Growth in EEC and Real GDP") + ylab("Cross correlation")+
  scale_y_continuous(limits=c(-1,1)) +
  theme_bw()+
  theme(legend.position = "none", plot.title=element_text(size=10))

print(ccf_growthEEC_GDP)



colnames(gdp_consumerconfidence) <- c("CEC","CCI","EEC","DATE","GDP Growth", "logCCI","logEEC", 
                                      "diff1_logCCI", "diff1_logEEC", "CCI Growth", "EEC Growth")

gdp_consumerconfidencegather <- gdp_consumerconfidence %>% gather(key = Series, value = Value, `CCI Growth`, `EEC Growth`, `GDP Growth`)

tikz(file = "GrowthinCC_GDP.tex", width = 6, height = 3.7)










gdp_consumerconfidenceplot <- ggplot(gdp_consumerconfidencegather) +
  geom_line(aes(x = DATE, y = Value, color = Series, group = Series), size = 1) +
  scale_y_continuous(breaks = c(-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7)) +
  scale_x_date(breaks = scales::date_breaks("11 months"), date_labels = "%Y-%m") +
  labs(x = "Time", y = "Growth Rate", title = "Growth Rate in Consumer Confidence and GDP", color = "Legend") +
theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))


print(gdp_consumerconfidenceplot)
dev.off()






























tikz(file = "CCF_CCI_GDP2018.tex", width = 6, height = 3.7)





# CCF Plots for Data Trucnated at 2018Q4 below.
df <- gdp_consumerconfidence

df_x <- eval(substitute(gdp_consumerconfidence[1:28, 2]),df)
df_y <- eval(substitute(gdp_consumerconfidence[1:28, 5]),df)
ccf.object <- ccf(df_x,df_y,plot=FALSE)
output_table <- cbind(lag=ccf.object$lag, x.corr=ccf.object$acf) %>% as_tibble() %>% mutate(Legend=ifelse(x.corr>0,"positive","negative"))
output_table %>% ggplot(aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=Legend))+scale_fill_manual(values=c("purple","red"))+ylab("Cross correlation")+scale_y_continuous(limits=c(-1,1))+theme_bw()+theme(legend.position = "none", plot.title=element_text(size=10))+ggtitle(title) -> p
ccf_CCI_GDP2018 <- ggplot(output_table, aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=Legend))+scale_fill_manual(values=c("purple","red"))+ geom_hline(yintercept=0.31) + geom_hline(yintercept = -0.31) + ggtitle("CCI and Real GDP Growth") + ylab("Cross Correlation")+
  scale_y_continuous(limits=c(-1,1)) +
  #theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

print(ccf_CCI_GDP2018)
dev.off()

tikz(file = "CCF_EEC_GDP2018.tex", width = 6, height = 3.7)






df <- gdp_consumerconfidence

df_x <- eval(substitute(gdp_consumerconfidence[1:28, 3]),df)
df_y <- eval(substitute(gdp_consumerconfidence[1:28, 5]),df)
ccf.object <- ccf(df_x,df_y,plot=FALSE)
output_table <- cbind(lag=ccf.object$lag, x.corr=ccf.object$acf) %>% as_tibble() %>% mutate(Legend=ifelse(x.corr>0,"positive","negative"))
output_table %>% ggplot(aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=Legend))+scale_fill_manual(values=c("purple","red"))+ylab("Cross correlation")+scale_y_continuous(limits=c(-1,1))+theme_bw()+theme(legend.position = "none", plot.title=element_text(size=10))+ggtitle(title) -> p
ccf_EEC_GDP2018 <- ggplot(output_table, aes(x=lag,y=x.corr)) + geom_bar(stat="identity",aes(fill=Legend))+scale_fill_manual(values=c("purple","red"))+ geom_hline(yintercept=0.31) + geom_hline(yintercept = -0.31) + ggtitle("EEC and Real GDP Growth") + ylab("Cross Correlation")+
  scale_y_continuous(limits=c(-1,1)) +
  #theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(plot.background = element_rect(fill = "#BFD5E3")) +
  theme(panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))

print(ccf_EEC_GDP2018)
dev.off()




# CCF Plots for Data Trucnated at 2018Q4 above.







