library(dplyr)
library(ggplot2)
library(tidyr)
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./week4Data.zip")
unzip(zipfile ="./week4Data.zip")
pathdata <- "./"
list.files("./")
setwd(pathdata)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Plot 1
totalYear <- NEI %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions)/1000000)
png('plot1.png')
barplot(totalYear$Emissions,names.arg = totalYear$year, ylim = c(0,10),
        col = "blue", ylab = "PM2.5 Emitted in (Million Tons)",
        xlab = "Year", main = "Total PM2 Emissions From All Sources") 
dev.off()
