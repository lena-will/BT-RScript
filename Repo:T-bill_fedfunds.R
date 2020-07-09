install.packages("zoo")
library(readxl)
library(ggplot2)
library(scales)
library(zoo)

fedfunds_csv <- read.csv("/Users/Lena/R/Bachelorarbeit/fedfunds.csv", na="NA", colClasses = c("Date", "numeric"))

tyield_csv <- read.csv("/Users/Lena/R/Bachelorarbeit/tyield.csv", na="NA", colClasses = c("Date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
tyield_csv$Month <- format(tyield_csv$Date, format = "%m")
tyield_csv$Year <- format(tyield_csv$Date, format = "%Y")

repo_twoyears_xls <- read_excel("/Users/Lena/R/Bachelorarbeit/repo_twoyears.xls" , na="NA")
repo_twoyears_xls$DATE <- as.Date(repo_twoyears_xls$DATE)
repo_twoyears_xls$RATE <- as.numeric(repo_twoyears_xls$RATE)
repo_twoyears_xls$Month <- format(repo_twoyears_xls$DATE, format = "%m")
repo_twoyears_xls$Year <- format(repo_twoyears_xls$DATE, format = "%Y")

tyield_mean <- aggregate(X3.MO ~ Month + Year, tyield_csv, mean)
tyield_mean$DATE <- as.yearmon(paste(tyield_mean$Year, tyield_mean$Month), "%Y %m")
tyield_mean <- tyield_mean[with(tyield_mean, order(tyield_mean$Year, tyield_mean$Month)), ]

repo_mean <- aggregate(RATE ~ Month + Year, repo_twoyears_xls, mean)
repo_mean$DATE <- as.yearmon(paste(repo_mean$Year, repo_mean$Month), "%Y %m")
repo_mean <- repo_mean[with(repo_mean, order(repo_mean$Year, repo_mean$Month)), ]

repo_tbill_spread <- (repo_mean$RATE - tyield_mean$X3.MO)
repo_tbill_spread <- as.data.frame(repo_tbill_spread)
repo_tbill_spread$Date <- repo_mean$DATE
repo_tbill_spread$Date <- as.Date(repo_tbill_spread$Date)

both_plot <- ggplot() +
  geom_line(aes(x = repo_tbill_spread$Date, y = repo_tbill_spread$repo_tbill_spread, color = "Repo/T-bill spread")) +
  geom_line(aes(x = fedfunds_csv$DATE, y = fedfunds_csv$FEDFUNDS, color = "Federal Funds Rate")) +
  theme(legend.position = c(.99, .99),
        legend.justification = c("right", "top")) +
  scale_x_date(date_breaks = "3 month", date_minor_breaks = "1 month", labels = date_format("%m/%Y")) + 
  scale_color_manual("", breaks = c("Repo/T-bill spread", "Federal Funds Rate"), values = c("Repo/T-bill spread"="red", "Federal Funds Rate"="blue"))
print(both_plot + labs(y = "Yield Spread/Federal Funds Rate", x = "Date"))

#both_plot <- both_plot +  guides(fill = guide_legend(title = "Legend"))
  
