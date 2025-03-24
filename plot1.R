fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
zipFile <- "pm25 emissions.zip"

if (!file.exists(zipFile)) {
        download.file(fileUrl, zipFile, mode = "wb")
}
data <- "Data"
if (!file.exists(data)) {
        unzip(zipFile)
}

NEI <- readRDS("summarySCC_PM25.rds")               # read files
SCC <- readRDS("Source_Classification_Code.rds")

Emissions <- tapply(NEI$Emissions, NEI$year, sum)   # calculate total sum of emissions/year

png("plot1.png", width=500, height=500)

barplot(Emissions/1000000, 
        xlab = "Year", 
        ylab = "PM2.5 Emissions (Million Metric Tons)", 
        main = "Plot 1 - Total PM2.5 Emissions (US, 1999-2008)", 
        ylim = c(0,8)
        )

dev.off()


