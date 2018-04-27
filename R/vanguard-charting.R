library(ggplot2)
library(httr)
library(jsonlite)

vanguardData <- function (productIDStr, startDate, endDate) {
  urlStr <- paste0("https://intlgra-graapp-72-prd.gra.international.vgdynamic.info/rs/gre/gra/datasets/auw-retail-price-history-mf.jsonp?",
                  "vars=portId:",productIDStr,
                  ",issueType:S,sDate:",startDate,
                  ",eDate:",endDate,
                  ",as_of:DAILY&callback=angular.callbacks._4")
  
  rawData <- GET(urlStr)  
  return (fromJSON(strsplit(content(rawData, "text"), "[()]")[[1]][[2]]))
}

globalStart <- "2017-02-20"
globalStart <- "1996-02-10"
globalEnd <- "2019-02-20"
vg.8129 <- vanguardData("8129", globalStart, globalEnd) # Vanguard Index Australian Shares Fund
vg.8145 <- vanguardData("8145", globalStart, globalEnd) # Vanguard Index International Shares Fund
vg.8146 <- vanguardData("8146", globalStart, globalEnd) # Vanguard Index Hedged International Shares Fund

# compare buy price of different products
ggplot() +
  geom_jitter(data=vg.8129$fundPricesBuy,
              aes(x=asOfDate,y=price), color='blue') +  # Vanguard Index Australian Shares Fund
  geom_jitter(data=vg.8145$fundPricesBuy,
              aes(x=asOfDate,y=price), color='red') +   # Vanguard Index International Shares Fund
  geom_jitter(data=vg.8146$fundPricesBuy,
              aes(x=asOfDate,y=price), color='green')   # Vanguard Index Hedged International Shares Fund

# compare buy vs sell vs nav price of one product
ggplot() +
  geom_jitter(data=vg.8129$fundPricesBuy,
            aes(x=asOfDate,y=price), color='blue') +
  geom_jitter(data=vg.8129$fundPricesSell,
            aes(x=asOfDate,y=price), color='red')
  geom_jitter(data=vg.8129$fundPricesNav,
            aes(x=asOfDate,y=price), color='green')
ggplot() +
    geom_jitter(data=vg.8145$fundPricesBuy,
                aes(x=asOfDate,y=price), color='blue') +
    geom_jitter(data=vg.8145$fundPricesSell,
                aes(x=asOfDate,y=price), color='red')
  geom_jitter(data=vg.8145$fundPricesNav,
              aes(x=asOfDate,y=price), color='green')
ggplot() +
    geom_jitter(data=vg.8146$fundPricesBuy,
                aes(x=asOfDate,y=price), color='blue') +
    geom_jitter(data=vg.8146$fundPricesSell,
                aes(x=asOfDate,y=price), color='red')
  geom_jitter(data=vg.8146$fundPricesNav,
              aes(x=asOfDate,y=price), color='green')
