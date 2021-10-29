library(tidyverse)
library(sf)
library(here)
library(janitor)
library(countrycode)
library(tmap)
library(tmaptools)

HDI <- read_csv(here::here("data", "Gender Inequality Index (GII).csv"),
                locale = locale(encoding = "latin1"),
                na = "..")
World <- st_read(here::here("data", "World_Countries__Generalized_.shp"))


HDIcols<- HDI %>%
  clean_names()%>%
  select(country, x2019, x2010)%>%
  mutate(difference=x2019-x2010)%>%
  slice(1:189,)%>%
  mutate(iso_code=countrycode(country, origin = 'country.name', destination = 'iso2c'))

Join_HDI <- World %>% 
  clean_names() %>%
  left_join(., 
            HDIcols,
            by = c("aff_iso" = "iso_code"))

tmap_mode("plot")
qtm(Join_HDI,
    fill="difference")