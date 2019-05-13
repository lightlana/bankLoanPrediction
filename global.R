if (!require(shinycssloaders)) install.packages("shinycssloaders")
if (!require(party)) install.packages("party")
if (!require(shinycssloaders)) install.packages("shinycssloaders")
if (!require(shiny)) install.packages("shiny")
if (!require(shinycssloaders)) install.packages("shinycssloaders")
if (!require(shiny)) install.packages("shiny")
if (!require(dplyr)) install.packages("dplyr")
if (!require(e1071)) install.packages("e1071")
if (!require(shinythemes)) install.packages("shinythemes")
if (!require(formattable)) install.packages("formattable")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(rsconnect)) install.packages("rsconnect")
if (!require(shinyBS)) install.packages("shinyBS")

library(party)
library(shiny)
library(caret)
library(shinycssloaders)
library(randomForestSRC)
library(dplyr)
library(e1071)
library(shinythemes)
library(formattable)
library(ggplot2)
library(rsconnect)




data = read.table("UniversalBank.csv", header= TRUE,sep ="," )


data$Education = as.factor(data$Education)
data$Personal.Loan = factor(data$Personal.Loan, 
                               labels = c('No', 'Yes'))
data$Securities.Account = as.factor(data$Securities.Account)
data$CreditCard = factor(data$CreditCard,
                            labels = c('No', 'Yes'))
data$Online = factor(data$Online,
                        labels = c('No', 'Yes'))
data$CD.Account = as.factor(data$CD.Account)
data$Family = as.factor(data$Family)


dataPredict = data[1,]



intro <- ("This is an application that attempts to predict whether a person gets a personal loan or not from various variables. We used various classification algorithms. 
          Deployement tabset serve as a tool to apply the trained models on a real example.")



ctree_intro <- ("CTree is a non-parametric class of regression trees embedding
tree-structured regression models into a well defined theory of conditional inference procedures.
It is applicable to all kinds of regression problems, including nominal, ordinal,
numeric, censored as well as multivariate response variables and arbitrary measurement
scales of the covariates. Package used: https://cran.r-project.org/web/packages/partykit/vignettes/ctree.pdf")

naive_intro <- ("CTree is a non-parametric class of regression trees embedding
tree-structured regression models into a well defined theory of conditional inference procedures.
It is applicable to all kinds of regression problems, including nominal, ordinal,
numeric, censored as well as multivariate response variables and arbitrary measurement
scales of the covariates. Package used: https://cran.r-project.org/web/packages/partykit/vignettes/ctree.pdf")
