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

# extract data related to motor vehicle sources only
mv <- grepl("vehicle", SCC$EI.Sector, ignore.case=TRUE)
SCC_mv <- SCC[mv,]
mv_NEI <- merge(NEI, SCC_mv, by="SCC")

# subset motor vehicles in NEI for Baltimore and LA
baltimore_la <- subset(mv_NEI, fips=="24510" | fips=="06037")
baltimore_la$city <- ifelse(baltimore_la$fips=="24510", "Baltimore", "Los Angeles")

# get total sum of motor vehicle emissions for Baltimore and LA/ yr
Emissions <- aggregate(Emissions ~ year + city, baltimore_la, sum)

library(ggplot2)

png("plot6.png", width=450, height=400)

ggplot(Emissions, aes(x = factor(year), y = Emissions, color = city)) +
        geom_bar(aes(fill = year), stat = "identity") +
        facet_grid(scales = "free", space = "free", .~city) +
        labs(x = "Year", y = expression("Total PM"[2.5]*" Emission (Kilo Tons)")) + 
        labs(title = expression(Plot6 - "PM"[2.5]*" Motor Vehicle Source Emissions - Baltimore vs. LA (1999-2008)"))

dev.off()