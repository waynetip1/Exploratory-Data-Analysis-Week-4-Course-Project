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

# plot 4
#filter out coal SCC
coalFilter <- filter(SCC,grepl('Coal',EI.Sector))
coalFilterData <- merge(coalFilter, NEI, 
                        by='SCC',all.x = T)

coalFilterDataTotal <- coalFilterData %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions)/1000)

p4<-ggplot(coalFilterDataTotal, aes(x=year, y=Emissions)) +
        geom_line(color='blue',size=1.5,aes(x=year,y=Emissions))+
        geom_point(color='red',size=3)+
        labs(title="United States Coal Combustion Emissions\n", x="Year",
             y="Emissions (Thousand Tons)")
png('plot4.png')
p4 
dev.off()