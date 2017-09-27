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
## Plot 3
totalMDType <-NEI %>%
        filter(fips=="24510") %>%
        group_by(year,type) %>%
        summarise(Emissions = sum(Emissions))

p3<-ggplot(totalMDType, aes(x=year, y=Emissions, colour = type, group=year)) +
        geom_line(size=1.5,aes(x=year,y=Emissions,group=type))+
        labs(title="Sources of Baltimore Emissions\n", x="Year",
             y="Emissions (Tons)", color="Emission Type\n")+
        geom_point(size=3)+
        guides(guide_legend(title = "Emission Type"))

png('plot3.png')
p3 
dev.off()
