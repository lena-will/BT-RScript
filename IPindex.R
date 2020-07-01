library("ggplot2")
library("scales")

ip_index <- read.csv("/Users/Lena/R/Bachelorarbeit/ip_index.csv", na="NA", colClasses = c("Date", "numeric"))

ip_index_plot <- ggplot(data=ip_index, aes(x=DATE, y=INDPRO)) + geom_line() +theme_bw()+ scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 month", labels = date_format("%Y"))
print(ip_index_plot + labs(y="Index 100=2012", x= "Date"))

ip_index_oneyear <- read.csv("/Users/Lena/R/Bachelorarbeit/ip_index_oneyear.csv", na="NA", colClasses = c("Date", "numeric"))
ip_index_oneyear_plot <- ggplot(data=ip_index_oneyear, aes(x=DATE, y=INDPRO)) + 
geom_line() + theme_bw()+
scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 month", labels = date_format("%m/%y"))
print(ip_index_oneyear_plot + labs(y="Index 100=2012", x= "Date"))


