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


## 3. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland ?


Select Baltimore (FIPS=24510) measures

```
NEIBalt <- NEI[NEI$fips=="24510",]
```
The result is a 2 096 observations data frame (out of the 6 497 651) :

```
str(NEIBalt)
'data.frame':	2096 obs. of  6 variables:
 $ fips     : chr  "24510" "24510" "24510" "24510" ...
 $ SCC      : chr  "10100601" "10200601" "10200602" "30100699" ...
 $ Pollutant: chr  "PM25-PRI" "PM25-PRI" "PM25-PRI" "PM25-PRI" ...
 $ Emissions: num  6.53 78.88 0.92 10.38 10.86 ...
 $ type     : chr  "POINT" "POINT" "POINT" "POINT" ...
 $ year     : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
```

In order to get the total Emissions per year, we have to sum all of them

```
NEIBaltSum <- aggregate(Emissions ~ year,NEIBalt,sum)
```

Open the PNG device

```
png(filename='plot2.png', width=480,height=480,units='px')
```

Plot an histogram using the standard plotting system

```
barplot(NEIBaltSum$Emissions,                     ## plots the histogram
        main = "Total PM2.5 Emissions in Baltimore",  ## gives a title
        names = NEIBaltSum$year,                  ## gives a name to the bars (years)
        xlab = "Year",                            ## gives a specified name to the x axis
        ylab = "Emissions (tons)",                ## gives a specified name to the y axis
        col="red")                                ## gives a red color to the histogram
```

Close the PNG device

```
dev.off()                                         ## Close the device  
```

The result is the following graph. 

**The PM2.5 Emissions have indeed decreased in Baltimore City from 1999 to 2008**.

![plot2.png](https://github.com/pierrewinkel/EDA_Project_Course-2/blob/master/plot2.png)


## 4. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City ? Which have seen increases in emissions from 1999–2008 ?


Groups the Baltimore measures by type : point, nonpoint, onroad & nonroad

```
NEIBaltbyType <- group_by(NEIBalt, type)
```

In order to get the total Emissions per year, we have to sum all of them by type and by year

```
NEIBaltbyTypeSum <- aggregate(NEIBaltbyType$Emissions,
                                by = list(type = NEIBaltbyType$type,
                                          year = NEIBaltbyType$year),
                                sum)
```

Open the PNG device

```
png(filename='plot3.png',width=480,height=480,units='px')              
```

Plot the graph using the ggplot2 system

```
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
```

Close the device

```
dev.off()                                         ## Close the device 
```

The result is the following graph. 

**The PM2.5 Emissions have decreased in Baltimore City from 1999 to 2008 for the Non Road, On Road and Non Point types.
But the Emissions have increased for the Point type**.

![plot3.png](https://github.com/pierrewinkel/EDA_Project_Course-2/blob/master/plot3.png)



## 5. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008 ?

Looking at the SCC file, I tried to find an easy way to identify coal combustion sources. I chose to look for "combustion" in the Standard Classification Code (SCC) level 1 and for "coal" in the SCC level 3

```
combustion <- grep(("[Cc]ombustion"),SCC$SCC.Level.One)
											 	  ## gives 569 integers
coal <- grep("[Cc]oal",SCC$SCC.Level.Three)       ## gives 181 integers
combustioncoal <- intersect(combustion,coal)      ## Only the lines containing both combustion and coal
												  ## : 80 integers
combustioncoalSCC <- SCC[combustioncoal,]$SCC
combustioncoalNEI <- NEI[NEI$SCC %in% combustioncoalSCC,]
												  ## extracts from NEI data only the data 
												  ## corresponding to these 80 SCC codes
```

The result is a 40347 observation dataframe :

```
str(combustioncoalNEI)
'data.frame':	40347 obs. of  6 variables:
 $ fips     : chr  "09001" "09003" "09005" "09007" ...
 $ SCC      : chr  "2104001000" "2104001000" "2104001000" "2104001000" ...
 $ Pollutant: chr  "PM25-PRI" "PM25-PRI" "PM25-PRI" "PM25-PRI" ...
 $ Emissions: num  1.13 3.84 1.45 1.57 2.18 ...
 $ type     : chr  "NONPOINT" "NONPOINT" "NONPOINT" "NONPOINT" ...
 $ year     : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
```

In order to get the total Emissions per year, we have to sum all of them

```
combustioncoalNEIagg <- aggregate(Emissions ~ year,combustioncoalNEI,sum)
```
Open the PNG device

```
png(filename='plot4.png',width=480,height=480,units='px')              
```
Plot an histogram using the standard plotting system

```
barplot(combustioncoalNEIagg$Emissions,           ## plots the histogram
        main = "Total PM2.5 Emissions from coal combustion sources", ## gives a title
        names = combustioncoalNEIagg$year,        ## gives a name to the bars (years)
        xlab = "Year",                            ## gives a specified nam to the x axis
        ylab = "Emissions (tons)",                ## gives a specified name to the y axis
        col="red")                                ## gives a red color to the histogram
```
Close the device

```
dev.off()                                         ## Close the device  
```

The result is the following graph. 

**The PM2.5 Emissions from coal combustion related sources have decreased in the United States from 1999 to 2008.**

![plot4.png](https://github.com/pierrewinkel/EDA_Project_Course-2/blob/master/plot4.png)


## 6. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City ?

Looking at the SCC file, I tried to find an easy way to identify the motor vehicle emissions.
There are the "On road" (highways) and "Non Road" (off road vehicles like 4x4, tractors, pavers...).

I found that all have in common the "Mobile Sources" in SCC.Level.One variable and "Vehicle" in the SCC.Level.Two variable (to avoid aircrafts, marine vessels...)

```
mobile <- grep(("[Mm]obile"),SCC$SCC.Level.One)    ## gives 1787 integers
vehicle <- grep(("[V]ehicle"),SCC$SCC.Level.Two)   ## gives 1452 integers
motorvehicle <- intersect(mobile,vehicle)          ## Only the lines containing both mobile and vehicle
												   ## : 1452 integers
motorvehicleSCC <- SCC[motorvehicle,]$SCC  
motorvehicleNEI <- NEIBalt[NEIBalt$SCC %in% motorvehicleSCC,]
												   ## extracts from NEIBalt data only the data 
												   ## corresponding to these 1452 SCC codes

```
It would have been enough to select only "Vehicle" int hte SCC Level 2.

The result is a 1 393 observations dataframe :

```
str(motorvehicleNEI)
'data.frame':	1393 obs. of  6 variables:
 $ fips     : chr  "24510" "24510" "24510" "24510" ...
 $ SCC      : chr  "220100123B" "220100123T" "220100123X" "220100125B" ...
 $ Pollutant: chr  "PM25-PRI" "PM25-PRI" "PM25-PRI" "PM25-PRI" ...
 $ Emissions: num  7.38 2.78 11.76 3.5 1.32 ...
 $ type     : chr  "ON-ROAD" "ON-ROAD" "ON-ROAD" "ON-ROAD" ...
 $ year     : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
```
 
In order to get the total Emissions per year, we have to sum all of them

```
motorvehicleNEIagg <- aggregate(Emissions ~ year,motorvehicleNEI,sum)
```
Open the PNG device

```
png(filename='plot5.png',width=480,height=480,units='px')
```

Plot an histogram using the standard plotting system

```
barplot(motorvehicleNEIagg$Emissions,            ## plots the histogram
        main = "Total PM2.5 Emissions from motor vehicles sources in Baltimore",
                                                 ## gives a title
        names = motorvehicleNEIagg$year,         ## gives a name to the bars (years)
        xlab = "Year",                           ## gives a specified name to the x axis
        ylab = "Emissions (tons)",               ## gives a specified name to the y axis
        col="red")                               ## gives a red color to the histogram
```
Close the device

```
dev.off()                                           
```

The result is the following graph. 

**The PM2.5 Emissions from motor vehicles related sources have decreased in Baltimore City from 1999 to 2008.**

![plot5.png](https://github.com/pierrewinkel/EDA_Project_Course-2/blob/master/plot5.png)


## 7. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions ?


Select Los Angeles (FIPS=06037) and Baltimore (FIPS=24510) measures

```
NEILA <- NEI[NEI$fips=="06037",]
NEIBalt <- NEI[NEI$fips=="24510",]
```

Let's use the motorvehicle vector defined in the last question

```
motorvehicleNEILA <- NEILA[NEILA$SCC %in% motorvehicleSCC,]
motorvehicleNEIBalt <- NEIBalt[NEIBalt$SCC %in% motorvehicleSCC,]
```

In order to get the total Emissions per year, we have to sum all of them

```
motorvehicleNEILAagg <- aggregate(Emissions ~ year,motorvehicleNEILA,sum)
motorvehicleNEIBaltagg <- aggregate(Emissions ~ year,motorvehicleNEIBalt,sum)
```

Gives a name to a new city column

```
motorvehicleNEILAagg$city <- "Los Angeles"
motorvehicleNEIBaltagg$city <- "Baltimore"
```

Sum the two aggregations : Baltimore & Los Angeles

```
motorvehicleNEIBaltLA <- rbind(motorvehicleNEILAagg,motorvehicleNEIBaltagg)
```
We get an 8 observation dataframe :

```
head(motorvehicleNEIBaltLA, 8)
  year Emissions        city
1 1999 6109.6900 Los Angeles
2 2002 7188.6802 Los Angeles
3 2005 7304.1149 Los Angeles
4 2008 6421.0170 Los Angeles
5 1999  403.7700   Baltimore
6 2002  192.0078   Baltimore
7 2005  185.4144   Baltimore
8 2008  138.2402   Baltimore
```

Open the PNG device

```
png(filename='plot6.png',width=480,height=480,units='px') 
```

Plot the graph using the ggplot2 system

```             
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

print(graph)                                      ## prints the graph
```
Close the device

```
dev.off()                                         
```
The result is the following graph. 

**The PM2.5 Emissions from motor vehicles related sources have decreased in Baltimore City from 1999 to 2008 and increased in Los Angeles County during the same period.**

**Baltimore has seen a decrease of 66%.**

**Los Angeles has sees a rise of 5%.**


![plot6.png](https://github.com/pierrewinkel/EDA_Project_Course-2/blob/master/plot6.png)

