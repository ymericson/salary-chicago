# library
library(treemap)
library(d3treeR)
library(rjson)
library(readxl)
library(tools)
library(stringr)
library(dplyr)
library(tidyverse)
library(htmltools)
library(htmlwidgets)


# get and clean data
df_app <- read_excel('data/foia_salary_11092020.csv')

# name
df_app <- df_app %>% mutate(name = paste(last,",",first,"",mi))
df_app$name <- str_to_title(df_app$name)

# dept & job titles
df_app$department <- str_to_title(df_app$dept_description)
df_app$job_titles <-gsub('^([0-9]+)|([IVXLCM]+)\\.?$','', df_app$title_description)
df_app$job_titles <- str_replace_all(df_app$job_titles,
                                     c("DIR" = "DIRECTOR",
                                       "SUPVSR" = "SUPERVISOR",
                                       "MGR" = "MANAGER"))
df_app$job_titles <- str_to_title(df_app$job_titles)
df_app$job_titles <- gsub("\\s*\\([^\\)]+\\)","",as.character(df_app$job_titles))

# earnings
df_app$annual_rate <- as.integer(df_app$annual_rate)
df_app$overtime_earned <- as.integer(as.character(df_app$overtime_earned))
df_app[is.na(df_app)] <- 0  
df_app$tot_wages <- df_app$annual_rate + df_app$overtime_earned

df_app <- df_app %>% select("name", "department", "job_titles", "annual_rate", 
                            "overtime_earned", "tot_wages") %>%
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
    "Salary" = annual_rate,
    "Overtime" = overtime_earned,
    "Total" = tot_wages
  )

df_app <- merge(df_app, count(df_app, Department), by="Department") %>%
  arrange(Name)
df_app$deptFreq <- paste0(df_app$Department, " ", paste0("(",df_app$n,")"))
