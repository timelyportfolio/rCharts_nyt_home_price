#this example plots two data sources in the NYT format
#1. the original Shiller 20 home price indices
#2. managers dataset included with R package performance analytics

#Although the cumulative growth transformation/formula is
#most commonly seen in finance, business, economics, there
#are various other potential applications.  Here is one interesting
#use of cumulative growth http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2909426/.
#Exponential growth series demonstrated in network analysis,
#biochemistry, agriculture could also work in this context.



require(rCharts)
require(reshape2)

p1 <- rCharts$new()
p1$setLib('libraries/widgets/nyt_home')
p1$setTemplate(script = "libraries/widgets/nyt_home/layouts/nyt_home.html")

p1$set(description = "The Standard & Poor's Case-Shiller Home Price Index for 20 major metropolitan areas is one of the most closely watched gauges of the housing market. The figures for April were released June 25. Figures shown here are not seasonally adjusted or adjusted for inflation.")

#get the data and convert to a format that we would expect from melted xts
#will be typical
#also original only uses a single value (val) and not other 
data <- read.csv("data/case-shiller-tiered2.csv", stringsAsFactors = F)

data.melt <- data.frame(
  format(as.Date(paste(data[,3],data[,4],"01",sep="-"),format = "%Y-%m-%d")),
  data[,c(1,2,5)]
)
colnames(data.melt) <- c("date",colnames(data.melt)[-1])


p1$set(
  data = data.melt,
  groups = "citycode",
  height = 0,
  width = 0
)
p1

#get manager dataset from PerformanceAnalytics
require(PerformanceAnalytics)

data(managers)
managers <- na.omit(managers)
managers.melt <- melt(
  data.frame( index( managers ), coredata(cumprod( managers+1 )*100 ) ),
  id.vars = 1
)
colnames(managers.melt) <- c("date", "manager","val")
managers.melt[,"date"] <- format(managers.melt[,"date"],format = "%Y-%m-%d")



#nyt plot of manager cumulative performance
p2 <- rCharts$new()
p2$setLib('libraries/widgets/nyt_home')
p2$setTemplate(script = "libraries/widgets/nyt_home/layouts/nyt_home.html")

p2$set(
  description = "This data comes from the managers dataset included in the R package PerformanceAnalytics.",
  data = managers.melt,
  groups = "manager",
  height = 0,
  width = 0
)

p2
