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

baltimore <- subset(NEI, fips=="24510")

# get total sum of emissions for Baltimore by year
bmore_emissions_type <- aggregate(Emissions ~ year + type, baltimore, sum)

library(ggplot2)

png("plot3.png", width=500, height=500)

ggplot(bmore_emissions_type,
       aes(factor(year), Emissions, fill = type)) +
        geom_bar(stat = "identity") +
        facet_grid(.~type, scales = "free", space = "free") + 
        theme_bw() +
        labs(x = "Year", 
             y = expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title = expression(Plot3 - "PM"[2.5]*" Emissions by Source Type (Baltimore City, MD, 1999-2008)"))

dev.off()