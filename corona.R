install.packages("zoo")
library(readxl)
library(ggplot2)
library(scales)
library(zoo)


fedfunds_csv <- read.csv("/Users/Lena/R/Bachelorarbeit/fedfunds.csv", na="NA", colClasses = c("Date", "numeric"))
tyield_csv <- read.csv("/Users/Lena/R/Bachelorarbeit/tyield.csv", na="NA", colClasses = c("Date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
repo_xls <- read_excel("/Users/Lena/R/Bachelorarbeit/repo.xls", na="NA")
repo_xls<- as.data.frame(repo_xls)
repo_xls$DATE<- as.Date(repo_xls$DATE)
repo_xls$RATE<- as.numeric(repo_xls$RATE)

tyield_csv$Month <- format(tyield_csv$Date, format = "%m")
tyield_csv$Year <- format(tyield_csv$Date, format = "%Y")
tyield_mean <- aggregate(X3.MO ~ Month + Year, tyield_csv, mean)
tyield_mean$Year <- as.numeric(tyield_mean$Year)
tyield_mean$DATE <- as.yearmon(paste(tyield_mean$Year, tyield_mean$Month), "%Y %m")
tyield_mean <- tyield_mean[with(tyield_mean, order(tyield_mean$Year, tyield_mean$Month)), ]

repo_xls$Month <- format(repo_xls$DATE, format = "%m")
repo_xls$Year <- format(repo_xls$DATE, format = "%Y")
repo_mean <- aggregate(RATE ~ Month + Year, repo_xls, mean)
repo_mean$DATE <- as.yearmon(paste(repo_mean$Year, repo_mean$Month), "%Y %m")
repo_mean <- repo_mean[with(repo_mean, order(repo_mean$Year, repo_mean$Month)), ]

repo_t_spread <- (repo_mean$RATE - tyield_mean$X3.MO)
print(repo_t_spread)

repo_t_spread <- as.data.frame(repo_t_spread)
repo_t_spread$Date <- repo_mean$DATE
repo_t_spread$Date <- as.Date(repo_t_spread$Date)


fedfunds_plot <- ggplot(data=fedfunds_csv, aes(x=DATE, y=FEDFUNDS)) + geom_line(color = "red") + theme_bw() + scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 month", labels = date_format("%m/%y"))
print(fedfunds_plot + labs(y="Percent", x= "Date"))

repo_t_spread_plot <- ggplot(data=repo_t_spread, aes(x=Date, y=repo_t_spread)) + geom_line(color = "blue") + theme_bw() + 
  scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 month", labels = date_format("%m/%y"))
print(repo_t_spread_plot + labs(y="Spread", x= "Date"))

both_plot <- ggplot() + 
  geom_line(aes(x= repo_t_spread$Date, y=repo_t_spread$repo_t_spread, color = "Repo/T-bill spread")) + 
  geom_line(aes(x=fedfunds_csv$DATE, y=fedfunds_csv$FEDFUNDS, color = "Federal Funds Rate")) +
  theme(legend.position = c(.99, .99),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.margin = margin(6, 6, 6, 6)) +
  scale_color_manual("", breaks = c("Repo/T-bill spread", "Federal Funds Rate"), values = c("Repo/T-bill spread"="red", "Federal Funds Rate"="blue"))+
  scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 month", labels = date_format("%m/%y"))
plot(both_plot + labs(y="", x= "Date"))



