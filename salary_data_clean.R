# library
library(treemap)
library(d3treeR)
library(rjson)
library(RSocrata)
library(tools)
library(stringr)
library(dplyr)
library(tidyverse)
library(htmltools)
library(htmlwidgets)


# get and clean data
df_app <- read.socrata("https://data.cityofchicago.org/resource/n4bx-5kf6.json")
df_date <- Sys.Date()
cols.num <- c("frequency_description", "annual_salary","hourly_rate")
df_app[cols.num] <- sapply(df_app[cols.num],as.numeric)
df_app$annual_salary <- ifelse(is.na(df_app$annual_salary), 
                               df_app$frequency_description * df_app$hourly_rate * 50, 
                               df_app$annual_salary)
df_app$name <- str_to_title(df_app$name)
df_app$department <- str_to_title(df_app$department)
df_app$job_titles <-gsub('^([0-9]+)|([IVXLCM]+)\\.?$','', df_app$job_titles)
df_app$job_titles <- str_replace_all(df_app$job_titles,
                                     c("DIR" = "DIRECTOR",
                                       "SUPVSR" = "SUPERVISOR",
                                       "MGR" = "MANAGER"))
df_app$job_titles <- str_to_title(df_app$job_titles)
df_app$job_titles <- gsub("\\s*\\([^\\)]+\\)","",as.character(df_app$job_titles))

df_app <- df_app %>% select("name", "department", "job_titles", "annual_salary") %>%
  mutate(department=recode(department,
                           "Admin Hearng" = "Administrative Hearings",
                           "Animal Contrl" = "Animal Control",
                           "Budget & Mgmt" = "Budget and Management",
                           "Copa" = "Civilian Office of Police Accountability",
                           "Dais" = "Assets, Info, and Services",
                           "Housing & Econ Dev" = "Planning and Development",
                           "Inspector Gen" = "Inspector General",
                           "License Appl Comm" = "License Appeal Commission",
                           "Oemc" = "Office of Emergency Mgmt and Comm",
                           "Police" = "Police Department",
                           "Streets & San" = "Streets and Sanitation",
                           "Transportn" = "Transportation",
                           "Water Mgmnt" = "Water Management"
                           )) %>% 
  dplyr::rename(
    "Name" = name,
    "Department" = department,
    "Job" = job_titles,
    "Salary" = annual_salary
  )

df_app <- merge(df_app, count(df_app, Department), by="Department") %>%
  arrange(Name)
df_app$deptFreq <- paste0(df_app$Department, " ", paste0("(",df_app$n,")"))



  

