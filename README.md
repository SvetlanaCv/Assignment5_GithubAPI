# Assignment5_GithubAPI
R code for extracting data from Github using GithubApi

The aim is to extract contributors from a repo and the number of commits they made to it. I expect that the creator of the repository will make the most but I also want to explore how much other contributors will generally add anything.

The code, specifically script.R, can be run in any R editor, several packages will need to be installed as shown here: install.packages("jsonlite"), install.packages("httr"), install.packages("shiny"), install.packages("ggplot2").

The code, when run, displays two graphs, one showing users which all contributed to a chosen project and the number of contributions they made to said project. The other shows how many repositorys each user has. Both graphs can be reorganised through the ui in alphabetical and numerical order and reversed. The aim is to see whether the main contributor of a repository is the creator of it and by how large of a margin, and how many people will only contribute a few times versus many times. The second graph allows for comparison, whether frequent contributors to the repository are also active in their own work more than those who contributed less.
