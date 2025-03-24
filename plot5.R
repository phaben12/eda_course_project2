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

# extract data of motor vehicle sources only
mv <- grepl("vehicle", SCC$EI.Sector, ignore.case=TRUE)
SCC_mv <- SCC[mv,]
mv_NEI <- merge(NEI, SCC_mv, by="SCC")

# subset motor vehicles in NEI for Baltimore only
baltimore <- subset(mv_NEI, fips=="24510")

# get total sum of motor vehicle emissions for Baltimore/ year
balt_mv <- tapply(baltimore$Emissions, baltimore$year, sum)

# change to df to be plotted
balt_mv <- as.data.frame(balt_mv)
names(balt_mv)[1] <- "Emissions"
rownames(balt_mv) <- c(1:4)
balt_mv$Year <- c(1999, 2002, 2005, 2008)

library(ggplot2)

png("plot5.png", width=450, height=480)

ggplot(balt_mv, aes(x = Year, y = Emissions)) +
        geom_bar(stat = "identity", fill = "darkorange", width = 0.75) +
        theme_bw() +
        labs(x = "Year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
        labs(title = expression(Plot5 - "PM"[2.5]*" Motor Vehicle Source Emissions (Baltimore City, MD, 1999-2008)"))

dev.off()