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

## Plot 2
totalMD <-NEI %>%
        filter(fips=="24510") %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

barplot(totalMD$Emissions,names.arg = totalYear$year,
        col = "orange", ylab = "PM2.5 Emitted in (Tons)", ylim = c(0,5000),
        xlab = "Year", main = "Maryland Total PM2 Emissions From All Sources")
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
# Plot 6
vehicleFilter <- filter(SCC,grepl('Mobile - On-Road',EI.Sector))
vehicleFilterData <- merge(vehicleFilter, NEI, 
                           by='SCC',all.x = T)

marylandVehicleFilterDataTotal <- vehicleFilterData %>%
        filter(fips=="24510")%>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

laVehicleFilterDataTotal <- vehicleFilterData %>%
        filter(fips=="06037")%>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

mdLaVehicle <- merge(marylandVehicleFilterDataTotal,
                     laVehicleFilterDataTotal, 
                     by='year',all.x = T)
names(mdLaVehicle) <- c("year","Maryland","LosAngeles")
mdLaVehicle <- gather(mdLaVehicle,"year",'Emissions')
names(mdLaVehicle) <- c("year","City","Emissions")

p6<-ggplot(mdLaVehicle, aes(x=year, y=Emissions, colour = City, group=year)) +
        
        geom_line(aes(x=year,y=Emissions,group=City), size=1.5)+
        labs(title="Vehicle Emission Comparison Between Baltimore and Los Angeles\n", x="Year",
             y="Emissions (Tons)", color="City\n")+
        geom_point(size=3,color='black')+
        guides(guide_legend(title = "City"))


png('plot6.png')
p6 
dev.off()



