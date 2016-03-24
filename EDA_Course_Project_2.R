## Set working directory
setwd("~/Coursera/Exploratory Data Analysis/Week 4")
## getwd()
## [1] "/Users/pierrewinkel/Coursera/Exploring Data/Week 1"

## Set libraries
## library(data.table)
library(dplyr)
library(ggplot2)
library("RColorBrewer")

# Visualiser une palette en spécifiant son nom
display.brewer.all()
display.brewer.pal(n = 8, name = 'RdBu')

## Downloads the zip file in a "data" directory
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile = "./data/data.zip")

## Unzips the file in the "data" directory                        
unzip ("./data/data.zip", exdir = "./data/")

## Creates data table with the readRDS() function
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

str(NEI)
## 'data.frame':	6497651 obs. of  6 variables:
##     $ fips     : chr  "09001" "09001" "09001" "09001" ...
##     $ SCC      : chr  "10100401" "10100404" "10100501" "10200401" ...
##     $ Pollutant: chr  "PM25-PRI" "PM25-PRI" "PM25-PRI" "PM25-PRI" ...
##     $ Emissions: num  15.714 234.178 0.128 2.036 0.388 ...
##     $ type     : chr  "POINT" "POINT" "POINT" "POINT" ...
##     $ year     : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...

summary(NEI)
# fips               SCC             Pollutant           Emissions       
# Length:6497651     Length:6497651     Length:6497651     Min.   :     0.0  
# Class :character   Class :character   Class :character   1st Qu.:     0.0  
# Mode  :character   Mode  :character   Mode  :character   Median :     0.0  
#                                                          Mean   :     3.4  
#                                                          3rd Qu.:     0.1  
#                                                          Max.   :646952.0  
# type                year     
# Length:6497651     Min.   :1999  
# Class :character   1st Qu.:2002  
# Mode  :character   Median :2005  
#                    Mean   :2004  
#                    3rd Qu.:2008  
#                    Max.   :2008  


## First graph : emissions from PM2.5 from 1999 to 2008

png(filename='plot1.png',
    width=480,height=480,units='px')              ## Open the PNG device

boxplot(log10(NEI$Emissions) ~ NEI$year,          ## plot a boxplot with all the measures
        main = expression("log"[10]*"(PM"[2.5]*" Emissions from all US Sources)"),
                                                  ## main = to give a title
        xlab = "Year",                            ## gives a specified name to the x axis
        ylab = expression("log"[10]*"(Emissions)"),
                                                  ## gives a specified name to the y axis
        col=brewer.pal(n = 4, name = "Oranges"))  ## Uses the Oranges brewer palette

dev.off()                                         ## Close the device  


## Second graph : emissions from PM2.5 from 1999 to 2008 in Baltimore

## Select Baltimore (FIPS=24510) measures
NEIBalt <- NEI[NEI$fips=="24510",]

png(filename='plot2.png',
    width=480,height=480,units='px')              ## Open the PNG device

boxplot(log10(NEIBalt$Emissions) ~ NEIBalt$year,  ## plot a boxplot with all the measures
        main = expression("log"[10]*"(PM"[2.5]*" Emissions in Baltimore)"),    ## main = to give a title
        xlab = "Year",                            ## gives a specified name to the x axis
        ylab = expression("log"[10]*"(Emissions)"),
                                                  ## gives a specified name to the y axis
        col=brewer.pal(n = 4, name = "Oranges"))  ## Uses the Oranges brewer palette

dev.off()                                         ## Close the device  


## Third graph : emissions from PM2.5 from 1999 to 2008 in Baltimore by type

## Select Baltimore (FIPS=24510) measures
NEIBaltbyType <- group_by(NEIBalt, type)

png(filename='plot3.png',
    width=480,height=480,units='px')              ## Open the PNG device

graph <- ggplot(NEIBaltbyType, aes(factor(year), log10(Emissions), fill = type)) +
                                                  ## plot log10(Emissions) (x) according to the year
                                                  ## with a filling different for each type
        geom_boxplot() +                          ## gives a form to the measures : boxplot
        facet_grid(.~type) +                      ## makes 4 subsets, 1 for each type
        xlab("Year") +                            ## gives a title to the x axis
        ylab(expression("log"[10]*"(PM"[2.5]*" Emission")) + 
                                                  ## gives a title to the y axis
        ggtitle(expression("log"[10]*"(PM"[2.5]*" Emissions), Baltimore City 1999-2008 by type")) +
                                                  ## gives a title to the plot
        theme(legend.position="none") +           ## removes the legend
        scale_fill_brewer(palette = "Oranges")    ## Uses the Oranges brewer palette

print(graph)                                      ## prints the graph variable

dev.off()                                         ## Close the device 



## Fourth graph : emissions from coal combustion-related sources between 1999 and 2008

## Looking at the SCC file, I tried to find an easy way to identify
## coal combustion sources. I chose to look for "combustion" in the 
## Standard Classification Code (SCC) level 1 and for "coal" in the SCC level 3
combustion <- grep(("[Cc]ombustion"),SCC$SCC.Level.One)
coal <- grep("[Cc]oal",SCC$SCC.Level.Three)
combustioncoal <- intersect(combustion,coal)
combustioncoalSCC <- SCC[combustioncoal,]$SCC
combustioncoalNEI <- NEI[NEI$SCC %in% combustioncoalSCC,]

## Removes the measures = 0
combustioncoalNEIsubset <- subset(combustioncoalNEI, combustioncoalNEI$Emissions !=0)

png(filename='plot4.png',
    width=480,height=480,units='px')              ## Open the PNG device

graph <- ggplot(combustioncoalNEIsubset, aes(factor(year), log10(Emissions), fill = factor(year))) +
                                                  ## plot log10(Emissions) (x) according to the year
        geom_boxplot(notch = TRUE) +              ## gives a form to the measures : boxplot
        xlab("Year") +                            ## gives a title to the x axis
        ylab(expression("log"[10]*"(PM"[2.5]*" Emissions)")) + 
                                                  ## gives a title to the y axis
        ggtitle(expression("log"[10]*"(PM"[2.5]*" Emissions from coal combustion), 1999-2008")) +
                                                  ## gives a title to the plot
        theme(legend.position="none") +           ## removes the legend
        scale_fill_brewer(palette="Oranges")      ## Uses the Oranges brewer palette

print(graph)                                      ## prints the graph variable

dev.off()                                         ## Close the device  


## Fifth graph : emissions from motor vehicle sources between 1999 and 2008 in Baltimore

## Looking at the SCC file, I tried to find an easy way to identify the motor vehicle emissions.
## There are the "On road" (highways) 
## and "Non Road" (off road vehicles like 4x4, tractors, pavers...)
## I found that all have in common the "Mobile Sources" in SCC.Level.One variable
## and "Vehicle" in the SCC.Level.Two variable (to avoid aircrafts, marine vessels...)

mobile <- grep(("[Mm]obile"),SCC$SCC.Level.One)
vehicle <- grep(("[V]ehicle"),SCC$SCC.Level.Two)
motorvehicle <- intersect(mobile,vehicle)
motorvehicleSCC <- SCC[motorvehicle,]$SCC
motorvehicleNEI <- NEIBalt[NEIBalt$SCC %in% motorvehicleSCC,]

png(filename='plot5.png',
    width=480,height=480,units='px')              ## Open the PNG device

graph <- ggplot(motorvehicleNEI, aes(x = factor(year), y = log10(Emissions), fill = factor(year))) +
                                                  ## plot log10(Emissions) (x) according to the year
        geom_boxplot() +                          
                                                  ## gives a form to the measures : boxplot
        xlab("Year") +                            ## gives a title to the x axis
        ylab(expression("log"[10]*"(PM"[2.5]*" Emission)")) + 
                                                  ## gives a title to the y axis
        ggtitle(expression("log"[10]*"(PM"[2.5]*" Emissions from motor vehicle),Baltimore City, 1999-2008")) +
                                                  ## gives a title to the plot
        theme(legend.position="none") +           ## removes the legend
        scale_fill_brewer(palette="Oranges")      ## Uses the Oranges brewer palette

print(graph)                                      ## prints the graph variable

dev.off()                                         ## Close the device  


## Sixth Graph : emissions from motor vehicle sources between 1999 and 2008
## in Baltimore and Los Angeles

## Select Los Angeles (FIPS=06037) and Baltimore (FIPS=24510) measures
NEILA <- NEI[NEI$fips=="06037",]
NEIBalt <- NEI[NEI$fips=="24510",]

## Let's use the motorvehicle vector defined in the 5th question
motorvehicleNEILA <- NEILA[NEILA$SCC %in% motorvehicleSCC,]
motorvehicleNEIBalt <- NEIBalt[NEIBalt$SCC %in% motorvehicleSCC,]

## In order to get the total Emissions per year, we have to sum all of them
## motorvehicleNEILAagg <- aggregate(Emissions ~ year,motorvehicleNEILA,sum)
## motorvehicleNEIBaltagg <- aggregate(Emissions ~ year,motorvehicleNEIBalt,sum)

## Gives a name to a new city column
motorvehicleNEILA$city <- "Los Angeles"
motorvehicleNEIBalt$city <- "Baltimore"

## Sum the two aggregations : Baltimore & Los Angeles
motorvehicleNEIBaltLA <- rbind(motorvehicleNEILA,motorvehicleNEIBalt)

png(filename='plot6.png',
    width=480,height=480,units='px')              ## Open the PNG device

graph <- ggplot(motorvehicleNEIBaltLA, aes(factor(year), log10(Emissions), fill=city)) +
        ## plot log10(Emissions) (x) according to the year
        ## with a filling different for each city
        facet_grid(.~city) +                      ## makes 2 subsets, 1 for each city
        geom_boxplot(notch = TRUE) +                          ## gives a form to the measures : bars
        xlab("Year") +                            ## gives a title to the x axis
        ylab(expression("log"[10]*"(PM"[2.5]*" Emission)")) + 
                                                  ## gives a title to the y axis
        ggtitle(expression("log"[10]*"(PM"[2.5]*" Emissions from motor vehicle),Baltimore City & Los Angeles, 1999-2008")) +
                                                  ## gives a title to the plot
        theme(legend.position="none") +           ## removes the legend
        scale_fill_brewer(palette="Oranges")      ## Uses the Oranges brewer palette
        
print(graph)                                      ## prints the graph variable

dev.off()                                         ## Close the device 
