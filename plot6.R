library(tidyr)
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./week4Data.zip")
unzip(zipfile ="./week4Data.zip")
pathdata <- "./"
list.files("./")
setwd(pathdata)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
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