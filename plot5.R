library(tidyr)
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./week4Data.zip")
unzip(zipfile ="./week4Data.zip")
pathdata <- "./"
list.files("./")
setwd(pathdata)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# plot 5
vehicleFilter <- filter(SCC,grepl('Mobile - On-Road',EI.Sector))
vehicleFilterData <- merge(vehicleFilter, NEI, 
                           by='SCC',all.x = T)

vehicleFilterDataTotal <- vehicleFilterData %>%
        filter(fips=="24510")%>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

p5<-ggplot(vehicleFilterDataTotal, aes(x=year, y=Emissions)) +
        geom_line(color='green',size=1.5,aes(x=year,y=Emissions))+
        geom_point(color='red',size=3)+
        labs(title="Maryland On-road Vehicle Emissions\n", x="Year",
             y="Emissions (Tons)")
png('plot5.png')
p5 
dev.off()