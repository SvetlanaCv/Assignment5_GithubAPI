#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
#install.packages("shiny")
library(shiny)
#install.packages("ggplot2")
library(ggplot2)

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
for(i in c(1:nrow(gitDF))){
username[i] = paste(gitDF$login[i])
noContributions[i] = as.numeric(gitDF$contributions[i])
}

noRepos = rep(0,nrow(gitDF))
for(i in c(1:nrow(gitDF))){
temp <- GET(paste(gitDF$url[i]), gtoken)
stop_for_status(temp)
json2 = content(temp)
gitDF2 = jsonlite::fromJSON(jsonlite::toJSON(json2))
noRepos[i] = as.numeric(gitDF2$public_repos)
}

data <- data.frame(username = username, noContributions=noContributions)
data2 <- data.frame(username=username, noRepos=noRepos)

#data$username <- factor(data$noContributions, levels = data$noContributions[order(data$username, decreasing=TRUE)])
#ggplot(data, aes(x = data$username, y = data$noContributions)) +labs(x="x", y="y") + theme_bw() + geom_bar(stat = "identity") +coord_flip()

server <- function(input,output,session){
  output$plot <- renderPlot({
    if(input$selectContr == "contrS"){
      data$username <- factor(data$username, levels = unique(data$username[order(data$noContributions, decreasing=TRUE)]))
    }
    else if(input$selectContr == "contrL"){
      data$username <- factor(data$username, levels = unique(data$username[order(data$noContributions, decreasing=FALSE)]))
      }
    else if(input$selectContr == "alphC"){
      data$username <- factor(data$username, levels = unique(data$username[order(data$username, decreasing=TRUE)]))
    }
    else if(input$selectContr == "alphCRev"){
      data$username <- factor(data$username, levels = unique(data$username[order(data$username, decreasing=FALSE)]))
    }
    ggplot(data, aes(x = data$username, y = data$noContributions))+labs(x="Username", y="Number of Contributions") + theme_bw() + geom_bar(stat = "identity") +coord_flip()
  })
  output$plot2 <- renderPlot({
    if(input$selectRepo == "repS"){
      data2$username <- factor(data2$username, levels = data2$username[order(data2$noRepos, decreasing=TRUE)])
    }
    else if(input$selectRepo == "repL"){
      data2$username <- factor(data2$username, levels = data2$username[order(data2$noRepos, decreasing=FALSE)])
    }
    else if(input$selectRepo == "alphR"){
      data2$username <- factor(data2$username, levels = data2$username[order(data2$username, decreasing=TRUE)])
    }
    else if(input$selectRepo == "alphRRev"){
      data2$username <- factor(data2$username, levels = data2$username[order(data2$username, decreasing=FALSE)])
    }
    ggplot(data2, aes(x = data2$username, y = data2$noRepos))+labs(x="Username", y="Number of Repositories") + theme_bw() + geom_bar(stat = "identity") +coord_flip()
  })
  }

ui <- fluidPage(titlePanel("Github Data Extraction Results"),
                fluidRow(
                column(12, selectInput("selectContr", "Order Contributions By", c("Contributions Decreasing" = "contrL",
                                                                    "Contributions Increasing" = "contrS",
                                                                    "Alphabetic" = "alphC",
                                                                    "Alphabetic Reverse" = "alphCRev"), selected = "contrL")),
                column(12, selectInput("selectRepo", "Order Repos By", c("Repos Decreasing" = "repL",
                                                                   "Repos Increasing" = "repS",
                                                                   "Alphabetic" = "alphR",
                                                                   "Alphabetic Reverse" = "alphRRev"), selected = "repL"))
                ),
                fluidRow(
                  plotOutput(("plot"))),
                fluidRow(
                  plotOutput(("plot2")))
                )

shinyApp(ui = ui, server = server)