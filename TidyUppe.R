# Read in & tidy data in order to create house price/real income dataframe.

library(dplyr)
library(readxl)
library(stringr)
library(lubridate)

housePrices <- read_excel("data/UKHousePrices.xls", range = "UK HP Since 1952!A6:C270")

housePrices <- housePrices %>% 
  select("X__1", "£") %>%
  rename(Year = X__1, `House Price [£]` = "£") %>%
  .[10:261,] %>%
  mutate(Quarter = addQuarter(.))

housePrices$Year <- str_replace(housePrices$Year, regex("Q\\d "), "")

housePricesByYear <- housePrices %>%
  group_by(Year) %>%
  summarise(`House Price [£]` = mean(`House Price [£]`))

addQuarter <- function(df) {
  i <- 1
  quarters <- character(length = nrow(df))
  for (j in 1:nrow(df)) {
    quarters[j] = paste0("Q", i)
    i <- i + 1
    if (i > 4) {
      i <- 1
    }
  }
  quarters
}

dispIncome <- read_excel("data/RealDispIncPerCap.xls", range="data!A8:B71")

dispIncome <- dispIncome %>%
  rename(Year = `Important notes`, Income = X__1)

HPIncome <- housePricesByYear %>%
  left_join(dispIncome, by = "Year")

HPIncome$Year <- ymd(paste0(HPIncome$Year, "0101"))

saveRDS(HPIncome, "data/data.rds")

generations <- tibble(
  Generation = c("Post-Millennial Generation",
                 "Millennial Generation",
                 "Generation X",
                 "Baby Boom Generation",
                 "Silent and Greatest Generations"),
  Born = c("1997 and later",
           "1981 to 1996",
           "1965 to 1980",
           "1946 to 1964",
           "1945 or earlier"),
  `Age in 2017` = c("20 and younger",
                    "21 to 36",
                    "37 to 52",
                    "53 to 71",
                    "72 and older")
)

saveRDS(generations, "data/generations.rds")

