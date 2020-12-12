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
library(here)
library(htmlwidgets)
library(shiny)
library(data.table)

# get and clean data
df <- read.socrata("https://data.cityofchicago.org/resource/n4bx-5kf6.json")
cols.num <- c("frequency_description", "annual_salary","hourly_rate")
df[cols.num] <- sapply(df[cols.num],as.numeric)
df$annual_salary <- ifelse(is.na(df$annual_salary), df$frequency_description * df$hourly_rate * 50, df$annual_salary)
df$name <- str_to_title(df$name)
df$department <- str_to_title(df$department)
df$job_titles <-gsub('^([0-9]+)|([IVXLCM]+)\\.?$','', df$job_titles)
df$job_titles<- str_replace_all(df_app$job_titles,
                               c("ADMINISTRATIVE" = "ADMIN",
                                 "COMMUNICATIONS" = "COMM",
                                 "ENGINEER" = "ENG",
                                 "TECHNICIAN" = "TECH",
                                 "OPERATIONS" = "OPS",
                                 "MAINTENANCE" = "MAINT",
                                 "PERFORMANCE" = "PERF",
                                 "CORPORATION" = "CORP",
                                 "INFORMATION" = "INFO",
                                 "SUPERINTENDENT" = "SPRNDT"
                                 ))
df$job_titles <- str_to_title(df$job_titles)
df$job_titles <- gsub("\\s*\\([^\\)]+\\)","",as.character(df$job_titles))
df <- df %>% select("name", "department", "job_titles", "annual_salary")

# change smaller departments to "OTHER DEPTS"
df$level1 <- df$department
df$level2 <- df$job_titles
df$level3 <- NA
top_depts <- head(names(sort(table(df$department), decreasing = TRUE)), 15)
df$level1[!(df$level1 %in% top_depts)] <- "OTHER DEPTS"
other_dept_rows <- (df$level1 == "OTHER DEPTS")
df[other_dept_rows,]$level2 <- df[other_dept_rows,]$department
df[other_dept_rows,]$level3 <- df[other_dept_rows,]$job_titles

# change smaller job titles to "Other"
for (dept in top_depts) {
  top_jobs <- head(names(sort(table(df[which(df$department == dept),]$job_titles), decreasing = TRUE)), 15)
  df[(df$department == dept) & !(df$job_titles %in% top_jobs),]$level2 <- "OTHER"
  dept_and_other_job <- (df$level1 == dept) & (df$level2 == "OTHER")
  df[dept_and_other_job,]$level3 <- df[dept_and_other_job,]$job_titles
}


# # group by level1 and job, convert numeric to USD
# level1_tot <- aggregate(df$annual_salary, by=list(Category=df$level1), FUN=sum) %>%
#   rename(level1 = Category, tot_salary_level1 = x)
# level1_tot$tot_salary_level1 <- paste('$', formatC(level1_tot$tot_salary_level1, big.mark=',', format = 'f'))
# level1_tot$tot_salary_level1 <- substr(level1_tot$tot_salary_level1, 1, nchar(level1_tot$tot_salary_level1)-5)
# 
# job_tot <- aggregate(df$annual_salary, by=list(Category=df$level2), FUN=sum) %>%
#   rename(level2 = Category, tot_salary_job = x)
# job_tot$tot_salary_job <- paste('$', formatC(job_tot$tot_salary_job, big.mark=',', format = 'f'))
# job_tot$tot_salary_job <- substr(job_tot$tot_salary_job, 1, nchar(job_tot$tot_salary_job)-5)
# 
# 
# # add salary to level1 and job title
# df <- merge(merge(df, level1_tot, by="level1"), job_tot, by="level2")
# df$tot_salary_level1 <- do.call("paste", c(df[c("level1", "tot_salary_level1")], sep = "\n"))
# df$tot_salary_job <- do.call("paste", c(df[c("level2", "tot_salary_job")], sep = "\n"))



# basic treemap
chicago_treemap <- treemap(df,
                           index=c("level1", "level2", "level3"),
                           vSize="annual_salary",
                           vColor="level1",
                           type="index",
                           title="Chicago Salaries by Department and Job Title",
                           n=1,
                           palette="Set3",
                           bg.labels=c("white"),
                           align.labels=list(
                             c("center", "center"), 
                             c("right", "bottom")
                           )  
)            

# make it interactive
chicago_inter <- d3tree2(chicago_treemap,  rootname="Salaries",
                         height = 460, width = 900)

# save the widget
saveWidget(chicago_inter, file = here("figures/ChicagoTreemap.html"))