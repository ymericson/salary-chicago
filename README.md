## 2020 City of Chicago Salaries

This R Shiny app shows salaries for Chicago of Chicago employees in calendar year 2020. The goal of this project was to
get a visual representation of how the city allocates its salary budget, and filter employees by salary and overtime pay. 

Here are the departments sorted by most salary + overtime pay:
- Police: 43.9%
- Fire: 17.7%
- Water Mgmt: 6.2%
- Sanitation: 5.7%
- Aviation: 4.8%
- Transportation: 3.6%



## Data

Salary dataset for current City fo Chicago employees is available on the [Chicago Open Data](https://data.cityofchicago.org/Administration-Finance/Current-Employee-Names-Salaries-and-Position-Title/xzkq-xp2w/data)
portal. However, the website does not show overtime pay, paid time off, or other additional compensation for its employees. I received the overtime data 
through Chicago Finance FOIA-request [here](https://www.chicago.gov/city/en/depts/fin/supp_info/fin_foia.html) and stored it in `/data`.

The data does not include employees working for Chicago Public Schools, Chicago Transit Authority, METRA, Cook County, or the state.

## Folder Structure

```
.
├── app                 # Shiny app files (user interface object `ui.R`, server function `server.R`, etc.)
├── data                # Salary data and cleanup files
├── figures             # Treemap files 
├── run.R               # Starts the Shiny App
├── init.R              # Installs R packages
└── README.md
```

## Deployment

The app was deployed using Heroku:

```
# Create the Heroku app
heroku apps:create APPNAME

# Reinitialize and commit to git
git init
git add . && git commit -m "commit message"

# Tell Heroku to use a custom R Shiny buildpack for the app
heroku create --buildpack https://github.com/virtualstaticvoid/heroku-buildpack-r.git

# Deploy
git push heroku main
```
