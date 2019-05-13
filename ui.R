


shinyUI(fluidPage(
  theme = shinytheme("sandstone"),
  titlePanel("Prediction of Personal Loan"),
  mainPanel(
    tabsetPanel(
      tabPanel(
        "Introduction",
        hr(),
        textOutput('intro'),
        hr(),
        h4("Ctree algorithm"), textOutput('ctree_intro'),
        hr(),
        h4("Naive Bayes"), textOutput('naive_intro')
      ),
      navbarMenu(
        "Data Visualisation",
        tabPanel(
          "Plot",
          hr(),
          sidebarPanel(
            selectInput(
              'plotvar',
              "Select variable to plot:",
              c(
                'Age' = 'age',
                'Income' = 'income',
                'Mortgage' = 'mortgage',
                'Credit Card' = 'card',
                'Online' = 'online',
                'Securities Account' = 'securities'
              )
            ),
            conditionalPanel(
              condition = "input.plotvar == 'age' || input.plotvar == 'income'",
              checkboxInput("normalcurve", "Display normal curve", value = FALSE)
            )
          ),
          mainPanel(
            conditionalPanel(condition = "input.plotvar == 'age'",
                             plotOutput('ageHist')),
            conditionalPanel(condition = "input.plotvar == 'income'",
                             plotOutput('incomeHist')),
            conditionalPanel(condition = "input.plotvar == 'mortgage'",
                             plotOutput('mortgageHist')),
            conditionalPanel(condition = "input.plotvar == 'card'",
                             plotOutput('cardBar')),
            conditionalPanel(condition = "input.plotvar == 'online'",
                             plotOutput('onlineBar')),
            conditionalPanel(condition = "input.plotvar == 'securities'",
                             plotOutput('securitiesBar'))
          )
        ),
        tabPanel("Table",
                 hr(),
                 sidebarPanel(
                   selectInput(
                     'plotvar',
                     "Select variable:",
                     c(
                       'Age' = 'age',
                       'Income' = 'income',
                       'Mortgage' = 'mortgage',
                       'Credit Card' = 'card',
                       'Online' = 'online',
                       'Securities Account' = 'securities'
                     )
                   )
                 ))
      ),
      tabPanel("Data",
               hr(),
               dataTableOutput("dataTable")),
      tabPanel(
        "C Tree",
        hr(),
        sidebarPanel(
          sliderInput(
            "slider1",
            "Train/Test split",
            min = 10,
            max = 90,
            step = 5,
            value = 80
          )
        ),
        mainPanel(
          h2('C Tree algorithm - Confusion matrix'),
          hr(),
          withSpinner(verbatimTextOutput("ctreeConf"))
        )
      ),
      tabPanel(
        "Naive Bayes",
        hr(),
        sidebarPanel(
          sliderInput(
            "slider2",
            "Train/Test split",
            min = 10,
            max = 90,
            step = 5,
            value = 80
          ),
          position = c('right')
        ),
        mainPanel(
          h2('Naive Bayes - Confusion matrix'),
          hr(),
          withSpinner(formattableOutput("bayes"))
        )
      ),
      tabPanel(
        title = "Deployment",
        h2("Predicted Category"),
        hr(),
        withSpinner(verbatimTextOutput("predicted")),
        
        hr(),
        
        fluidRow(
          column(
            3,
            h4("Information about person"),
            selectInput(
              "credit",
              label = "Credit Card",
              choices = list("Yes" = 1, "No" = 0),
              selected = 1
            ),
            selectInput(
              "cdaccount",
              label = "CD Acount",
              choices = list("Yes" = 1, "No" = 0),
              selected = 1
            )
          ),
          column(
            3,
            selectInput(
              "education",
              label = "Education",
              choices = list(
                "High School" = 1,
                "Undergraduate" = 2,
                "Graduate" = 3
              ),
              selected = 1
            ),
            selectInput(
              "family",
              label = "Family",
              choices = list(
                "Single" = 1,
                "Married" = 2,
                "Divorced" = 3,
                "Other" = 4
              ),
              selected = 1
            ),
            numericInput('age', label = 'Age', value =
                           0)
            
          ),
          column(
            3,
            numericInput("income", label = "Income", value = 0),
            numericInput("ccavg", label = "CCAVg", value = 0),
            selectInput(
              "Model",
              label = "Model",
              choices = list("Ctree" = 'ctree', "Naive Bayes" = 'bayes')
            )
          ),
          column(3,
                 hr(),
                 actionButton(
                   "action", label = "Predict", icon = icon("refresh")
                 ))
        )
      ),
      tabPanel(
        "Multiple Classification",
        sidebarPanel(
          hr(),
          sliderInput(
            "slider3",
            "Train/Test split",
            min = 10,
            max = 90,
            step = 5,
            value = 80
          ),
          hr(),
          selectInput(
            'inputMulticlass',
            'Predicted variable',
            choices = list(
              'Family' = 'family',
              'Education' = 'education',
              'Both' = 'both'
            )
          )
      ),
        mainPanel(
          h2("Results"),
          hr(),
          withSpinner(formattableOutput("education")),
          
          withSpinner(formattableOutput("family"))
        )
      )
      
    )
  )
))