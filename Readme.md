# Exploratory Data Analysis Course Project 2

## Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health.

In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. 

In the following work, we use the 1999, 2002, 2005, and 2008 data.

## Description of the work
1. Setting the working environmment and getting the data
2. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008 ?
3. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland ?
4. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City ? Which have seen increases in emissions from 1999–2008 ?
5. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008 ?
6. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City ?
7. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions ?

## Description of the code : EDA Project Course 2.R

### 1. Setting and getting the data

#### Setting the working environment
```setwd("~/Coursera/Exploratory Data Analysis/Week 4")```

#### Set libraries
```
library(dplyr)
library(ggplot2)
```
#### Downloads the zip file in a "data" directory
```
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile = "./data/data.zip")
```
#### Unzips the file in the "data" directory                        
```
unzip ("./data/data.zip", exdir = "./data/")
```

#### Creates data table with the readRDS() function
```
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
```
Let's have a look to the data :

```
str(NEI)
'data.frame':	6497651 obs. of  6 variables:
     $ fips     : chr  "09001" "09001" "09001" "09001" ...
     $ SCC      : chr  "10100401" "10100404" "10100501" "10200401" ...
     $ Pollutant: chr  "PM25-PRI" "PM25-PRI" "PM25-PRI" "PM25-PRI" ...
     $ Emissions: num  15.714 234.178 0.128 2.036 0.388 ...
     $ type     : chr  "POINT" "POINT" "POINT" "POINT" ...
     $ year     : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
```
```
summary(NEI)
fips               SCC             Pollutant           Emissions       
Length:6497651     Length:6497651     Length:6497651     Min.   :     0.0  
Class :character   Class :character   Class :character   1st Qu.:     0.0  
Mode  :character   Mode  :character   Mode  :character   Median :     0.0  
                                                         Mean   :     3.4  
                                                         3rd Qu.:     0.1  
                                                         Max.   :646952.0  
type                year     
Length:6497651     Min.   :1999  
Class :character   1st Qu.:2002  
Mode  :character   Median :2005  
                   Mean   :2004  
                   3rd Qu.:2008  
                   Max.   :2008  
```

## 2. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008 ?

In order to get the total Emissions per year, we have to sum all of them

```
NEIagg <- aggregate(Emissions ~ year,NEI,sum)
```
Open the PNG device

```
png(filename='plot1.png', width=480,height=480,units='px')              
```
Plot an histogram using the standard plotting system

```
barplot(NEIagg$Emissions,                         ## plots the histogram
        main = "Total PM2.5 Emissions from all US Sources", ## gives a title
        names = NEIagg$year,                      ## gives a name to the bars (years)
        xlab = "Year",                            ## gives a specified name to the x axis
        ylab = "Emissions (tons)",                ## gives a specified name to the y axis
        col="red")                                ## gives a red color to the histogram
```
Close the device

```  
dev.off() 
```
The result is the following graph. 

**The PM2.5 Emissions have indeed decreased in the United States from 1999 to 2008**.

![plot1.png](https://github.com/pierrewinkel/EDA_Project_Course-2/blob/master/plot1.png)


## Second graph : emissions from PM2.5 from 1999 to 2008 in Baltimore

## Select Baltimore (FIPS=24510) measures
NEIBalt <- NEI[NEI$fips=="24510",]
## In order to get the total Emissions per year, we have to sum all of them
NEIBaltSum <- aggregate(Emissions ~ year,NEIBalt,sum)

png(filename='plot2.png',
    width=480,height=480,units='px')              ## Open the PNG device

barplot(NEIBaltSum$Emissions,                         ## plot the histogram
        main = "Total PM2.5 Emissions in Baltimore", ## main = to give a title
        names = NEIBaltSum$year,                      ## gives a name to the bars (years)
        xlab = "Year",                            ## xlab to give a specified nam to the x axis
        ylab = "Emissions (tons)",                ## ylab to give a specified name to the y axis
        col="red")                                ## col to give a color to the histogram

dev.off()                                         ## Close the device  


## Third graph : emissions from PM2.5 from 1999 to 2008 in Baltimore by type

## Select Baltimore (FIPS=24510) measures
NEIBaltbyType <- group_by(NEIBalt, type)
## In order to get the total Emissions per year, we have to sum all of them
NEIBaltbyTypeSum <- aggregate(NEIBaltbyType$Emissions,
                                by = list(type = NEIBaltbyType$type,
                                          year = NEIBaltbyType$year),
                                sum)

png(filename='plot3.png',
    width=480,height=480,units='px')              ## Open the PNG device

graph <- ggplot(NEIBaltbyTypeSum, aes(factor(year), x, fill = type)) +
                                                  ## plot Emission (x) according to the year
                                                  ## with a filling different for each type
        geom_bar(stat = "identity") +             ## gives a form to the measures : bars
        facet_grid(.~type) +                      ## makes 4 subsets, 1 for each type
        xlab("Year") +                            ## gives a title to the x axis
        ylab(expression("Total PM"[2.5]*" Emission (tons)")) + 
                                                  ## gives a title to the y axis
        ggtitle(expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by type")) +
                                                  ## gives a title to the plot
        theme(legend.position="none")             ## removes the legend

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

## In order to get the total Emissions per year, we have to sum all of them
combustioncoalNEIagg <- aggregate(Emissions ~ year,combustioncoalNEI,sum)

png(filename='plot4.png',
    width=480,height=480,units='px')              ## Open the PNG device

barplot(combustioncoalNEIagg$Emissions,           ## plot the histogram
        main = "Total PM2.5 Emissions from coal combustion sources", ## main = to give a title
        names = combustioncoalNEIagg$year,        ## gives a name to the bars (years)
        xlab = "Year",                            ## xlab to give a specified nam to the x axis
        ylab = "Emissions (tons)",                ## ylab to give a specified name to the y axis
        col="red")                                ## col to give a color to the histogram

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

## In order to get the total Emissions per year, we have to sum all of them
motorvehicleNEIagg <- aggregate(Emissions ~ year,motorvehicleNEI,sum)

png(filename='plot5.png',
    width=480,height=480,units='px')              ## Open the PNG device

barplot(motorvehicleNEIagg$Emissions,             ## plot the histogram
        main = "Total PM2.5 Emissions from motor vehicles sources in Baltimore",
                                                  ## main = to give a title
        names = motorvehicleNEIagg$year,          ## gives a name to the bars (years)
        xlab = "Year",                            ## xlab to give a specified nam to the x axis
        ylab = "Emissions (tons)",                ## ylab to give a specified name to the y axis
        col="red")                                ## col to give a color to the histogram

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
motorvehicleNEILAagg <- aggregate(Emissions ~ year,motorvehicleNEILA,sum)
motorvehicleNEIBaltagg <- aggregate(Emissions ~ year,motorvehicleNEIBalt,sum)

## Gives a name to a new city column
motorvehicleNEILAagg$city <- "Los Angeles"
motorvehicleNEIBaltagg$city <- "Baltimore"

## Sum the two aggregations : Baltimore & Los Angeles
motorvehicleNEIBaltLA <- rbind(motorvehicleNEILAagg,motorvehicleNEIBaltagg)

png(filename='plot6.png',
    width=480,height=480,units='px')              ## Open the PNG device

graph <- ggplot(motorvehicleNEIBaltLA, aes(factor(year), Emissions, fill=city)) +
        ## plot Emission (x) according to the year
        ## with a filling different for each city
        facet_grid(.~city) +                      ## makes 2 subsets, 1 for each city
        geom_bar(stat = "identity") +             ## gives a form to the measures : bars
        xlab("Year") +                            ## gives a title to the x axis
        ylab(expression("Total PM"[2.5]*" Emission (tons)")) + 
                                                  ## gives a title to the y axis
        ggtitle(expression("PM"[2.5]*" Motor Vehicles Emissions, Baltimore City & Los Angeles, 1999-2008")) +
                                                  ## gives a title to the plot
        theme(legend.position="none")             ## removes the legend

print(graph)                                      ## prints the graph variable

dev.off()                                         ## Close the device 