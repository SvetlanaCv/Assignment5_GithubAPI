#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
#install.pakages("sunburstR")
library(sunburstR)
library(shiny)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")
myapp <- oauth_app(appname = "Assignment_5_Svetlana_Cvetic", key = "dc80d9f1d7a365bcad95", secret = "b333c9422fe2e927ef00e78ac18cae69af24d911")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/repos/dipakkr/A-to-Z-Resources-for-Students/contributors", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "dipakkr/datasharing", "created_at"] 

#how to extract data by index and place into out
#out<-list(json1[[30]]$login, json1[[30]]$contributions)

username = rep(0,30)
noContributions = rep(0,30)

#add new data to file
for(i in c(1:30)){
username[i] = json1[[i]]$login
noContributions[i] = json1[[i]]$contributions
}

contributions <- data.frame(username = username, noContributions = noContributions)
#transform(contributions, username = as.numeric(username))
print(contributions)

noRepos = rep(0,30)
username = rep(0,30)

for(i in c(1:30)){
temp <- GET(paste(list(json1[[i]]$url)), gtoken)
stop_for_status(temp)
json2 = content(temp)
gitDF2 = jsonlite::fromJSON(jsonlite::toJSON(json2))
noRepos[i] = (gitDF2$public_repos)
username[i] = (gitDF2$login)
}

repos <- data.frame(username = username, noRepos = noRepos)
print(repos)
plot(contributions)
plot(repos)
#str(contributions)
#sapply(contributions, mode)
