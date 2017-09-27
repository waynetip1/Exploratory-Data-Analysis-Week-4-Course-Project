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

## Plot 2
totalMD <-NEI %>%
        filter(fips=="24510") %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

png('plot2.png')
barplot(totalMD$Emissions,names.arg = totalYear$year,
        col = "orange", ylab = "PM2.5 Emitted in (Tons)", ylim = c(0,5000),
        xlab = "Year", main = "Maryland Total PM2 Emissions From All Sources")
dev.off()
