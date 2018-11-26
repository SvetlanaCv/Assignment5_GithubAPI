#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

library(sunburstR)
library(shiny)
library(lattice)
library(ggplot2)

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

username = rep(0,nrow(gitDF))
noContributions = rep(0, nrow(gitDF))
#add new data to file
for(i in c(1:nrow(gitDF))){
username[i] = gitDF$login[i]
noContributions[i] = gitDF$contributions[i]
}

#print(username)
#print(noContributions)

noRepos = rep(0,nrow(gitDF))

for(i in c(1:nrow(gitDF))){
temp <- GET(paste(list(gitDF$url[i])), gtoken)
stop_for_status(temp)
json2 = content(temp)
gitDF2 = jsonlite::fromJSON(jsonlite::toJSON(json2))
noRepos[i] = (gitDF2$public_repos)
}

data <- data.frame(username = username, noContributions=noContributions)
#data <- data[order(data$username),]
print(data)
data <- data[order(data$username, decreasing=FALSE),]
#print(data)
#data<-data[order(data$username, decreasing=TRUE),]
#print(data)
plot(data$noContributions, data$username)
#lines(data$username,data$noRepos , col="green" , lwd=3 , pch=19 , type="l" )

server <- function(input,output,session){
  output$plot <- renderPlot({
    
    #if(input$select == "alph"){
    #  data <- data[order(data$username, decreasing=FALSE),]
    #  plot(data$noContributions~data$username , type="b" , bty="l" , xlab="Username" , ylab="Number of Contributions" , col="blue" , lwd=3 , pch=17 )
    #  lines(data$noRepos~data$username , col="green" , lwd=3 , pch=19 , type="b" )
    #  }
    #if(input$select == "revalph"){
    #  data <- data[order(data$username, decreasing=TRUE),]
    #  data<-data[dim(data)[1]:1,]
    #  plot(data$noContributions~data$username , type="b" , bty="l" , xlab="Username" , ylab="Number of Contributions" , col="blue" , lwd=3 , pch=17 )
    #  lines(data$noRepos~data$username , col="green" , lwd=3 , pch=19 , type="b" )
    #}
    
  })
  }

ui <- fluidPage(titlePanel("Github Data Extraction Results"),
                sidebarPanel("Options",
                    selectInput("select", "Order By", c("Alphabetic" = "alph",
                                                         "Reverse Alphabetic" = "revalph",
                                                         "Contributions" = "contr",
                                                         "Repositories" = "repos"),
                                selected = "alph")
                ),
                mainPanel("Graph"),
                plotOutput(("plot")))

shinyApp(ui = ui, server = server)