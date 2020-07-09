library(ggplot2)
library(scales)

fedrate <- read.csv("/Users/Lena/R/Bachelorarbeit/federalfundsrate.csv", na = "NA", colClasses = c("Date", "numeric"))

fedrate_plot <- ggplot() + geom_line(aes(x=fedrate$DATE, y=fedrate$FEDFUNDS)) + theme_bw() + 
  scale_x_date(date_breaks = "1 year", date_minor_breaks = "1 year", labels = date_format("%y"))
print(fedrate_plot + labs(y = "Percent", x = "Date"))

