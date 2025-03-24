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

#extract data related to coal combustion sources only
coal <- grepl("coal", SCC$EI.Sector, ignore.case=TRUE)
SCC_coal <- SCC[coal,]
coal_NEI <- merge(NEI, SCC_coal, by="SCC")

# total emissions/ year saved as a df
coal_sum <- tapply(coal_NEI$Emissions, coal_NEI$year, sum)
coal_sum <- as.data.frame(coal_sum)
names(coal_sum)[1] <- "Emissions"
rownames(coal_sum) <- c(1:4)
coal_sum$Year <- c(1999, 2002, 2005, 2008)

png("plot4.png", width=500, height=450)

ggplot(coal_sum, aes(x = factor(Year), 
                     y = Emissions/10^5)) +
        geom_bar(stat = "identity", 
                 fill ="darkorange", 
                 width = 0.75) +
        theme_bw() +
        labs(x = "Year", 
             y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
        labs(title = expression(Plot4 - "PM"[2.5]*" Coal Combustion Source Emissions Across US (1999-2008)"))

dev.off()