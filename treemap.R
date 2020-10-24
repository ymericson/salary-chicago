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

# get and clean data
df <- read.socrata("https://data.cityofchicago.org/resource/n4bx-5kf6.json")
cols.num <- c("frequency_description", "annual_salary","hourly_rate")
df[cols.num] <- sapply(df[cols.num],as.numeric)
df$annual_salary <- ifelse(is.na(df$annual_salary), df$frequency_description * df$hourly_rate * 50, df$annual_salary)   
df$department <- str_to_title(c(df$department))
df$job_titles <- str_to_title(c(df$job_titles))
df <- df %>% select("name", "department", "job_titles", "annual_salary")

# group by dept and job, convert numeric to USD
dept_tot <- aggregate(df$annual_salary, by=list(Category=df$department), FUN=sum) %>%
  rename(department = Category, tot_salary_dept = x)
dept_tot$tot_salary_dept <- paste('$', formatC(dept_tot$tot_salary_dept, big.mark=',', format = 'f'))
dept_tot$tot_salary_dept <- substr(dept_tot$tot_salary_dept, 1, nchar(dept_tot$tot_salary_dept)-5)

job_tot <- aggregate(df$annual_salary, by=list(Category=df$job_titles), FUN=sum) %>%
  rename(job_titles = Category, tot_salary_job = x)
job_tot$tot_salary_job <- paste('$', formatC(job_tot$tot_salary_job, big.mark=',', format = 'f'))
job_tot$tot_salary_job <- substr(job_tot$tot_salary_job, 1, nchar(job_tot$tot_salary_job)-5)

# add salary to department and job title
df <- merge(merge(df, dept_tot, by="department"), job_tot, by="job_titles")
df$tot_salary_dept <- do.call("paste", c(df[c("department", "tot_salary_dept")], sep = "\n"))
df$tot_salary_job <- do.call("paste", c(df[c("job_titles", "tot_salary_job")], sep = "\n"))



# basic treemap
chicago_treemap <- treemap(df,
                           index=c("tot_salary_dept","tot_salary_job"),
                           vSize="annual_salary",
                           vColor="department",
                           type="index",
                           title="Chicago Salaries by Department and Job Title",
                           n=1,
                           palette="Set2",
                           bg.labels=c("white"),
                           align.labels=list(
                             c("center", "center"), 
                             c("right", "bottom")
                           )  
)            

# make it interactive ("rootname" becomes the title of the plot):
chicago_inter <- d3tree2(chicago_treemap,  rootname="Salaries")




# save the widget
# library(htmlwidgets)
# saveWidget(inter, file=paste0( getwd(), "/HtmlWidget/interactiveTreemap.html"))