fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
zipFile <- "pm25 emissions.zip"

if (!file.exists(zipFile)) {
        download.file(fileUrl, zipFile, mode = "wb")
}

data <- "Data"
if (!file.exists(data)) {
        unzip(zipFile)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore <- subset(NEI, fips=="24510")                           # subset NEI for Baltimore

bmore_emissions <- tapply(baltimore$Emissions, baltimore$year, sum)   # total sum of emissions

png("plot2.png", width=500, height=500)

barplot(bmore_emissions, 
        xlab = "Year", 
        ylab = "PM2.5 Emissions (tons)", 
        main = "Plot 2 - Total PM2.5 Emissions (Baltimore City, MD, 1999-2008)", 
        ylim = c(0, 3500))

dev.off()