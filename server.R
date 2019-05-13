


shinyServer(function(input, output) {
  output$dataTable <- renderDataTable({
    data
  })
  
  output$intro <- renderText({
    intro
  })
  
  output$ctree_intro <- renderText({
    ctree_intro
  })
  
  output$naive_intro <- renderText({
    naive_intro
  })
  
  output$ageHist <- renderPlot({
    if (input$normalcurve) {
      ggplot(data) + geom_histogram(aes(x = Age),
                                    bins = 40,
                                    fill = 'grey',
                                    color = 'black')  + labs(y = "Count", title = 'Histogram of age') + stat_function(fun = dnorm, args = list(mean = mean(data$Age), sd = sd(data$Age)))
    } else {
      ggplot(data) + geom_histogram(aes(x = Age),
                                    fill = 'grey',
                                    color = 'black',
                                    bins = 40) + labs(y = "Count", title = 'Histogram of age')
    }
  })
  
  output$incomeHist <-
    renderPlot({
      ggplot(data) + geom_histogram(aes(x = Income), fill = 'grey', color = 'black') + labs(y =
                                                                                              "Count", title = 'Histogram of Income')
      
    })
  
  output$mortgageHist <-
    renderPlot({
      ggplot(data) + geom_histogram(aes(x = Mortgage), fill = 'grey', color =
                                      'black') + labs(y = "Count", title = 'Histogram of Mortgage')
    })
  
  output$cardBar <-
    renderPlot({
      ggplot(data) + geom_bar(aes(x = CreditCard), fill = 'grey', color = 'black') + labs(y =
                                                                                            "Count", title = 'Barplot of Credit card')
    })
  
  output$securitiesBar <-
    renderPlot({
      ggplot(data) + geom_bar(aes(x = Securities.Account)) + labs(y = "Count", x = 'Securities Account', title = 'Barplot of Securities Account') + scale_fill_brewer(palette = "Set1")
    })
  
  output$onlineBar <-
    renderPlot({
      ggplot(data) + geom_bar(aes(x = Online), fill = 'grey', color = 'black') + labs(y =
                                                                                        "Count", title = 'Barplot of Online')
    })
  
  #Ctree
  dataSplit1 <- reactive({
    train = input$slider1 / 100
    test = 1 - (input$slider1 / 100)
    
    
    set.seed(42)
    ind = sample(2,
                 nrow(data),
                 replace = TRUE,
                 prob = c(train, test))
    
    
    train.data = data[ind == 1, ]
    test.data = data[ind == 2, ]
    
    list(trainData = train.data, testData = test.data)
  })
  
  ctreeF = reactive({
    W = ifelse(
      dataSplit2()$trainData$result == 'r2l' |
        dataSplit2()$trainData$result == 'probe',
      5,
      1
    )
    data_ctree = party::ctree(Personal.Loan ~ ., data = dataSplit1()$trainData)
    testPred = predict(data_ctree, newdata = dataSplit1()$testData)
    list(tree = data_ctree, predict = testPred)
  })
  
  output$ctreeConf <- renderPrint({
    confusionMatrix(data = ctreeF()$predict,
                    reference = dataSplit1()$testData$Personal.Loan)
  })
  
  
  #Bayes
  
  dataSplit2 <- reactive({
    train = input$slider2 / 100
    test = 1 - (input$slider2 / 100)
    
    
    set.seed(42)
    ind = sample(2,
                 nrow(data),
                 replace = TRUE,
                 prob = c(train, test))
    
    
    train.data = data[ind == 1, ]
    test.data = data[ind == 2, ]
    
    list(trainData = train.data, testData = test.data)
  })
  
  naivebayes = reactive({
    classifier = e1071::naiveBayes(dataSplit2()$trainData[, -10],
                                   dataSplit2()$trainData$Personal.Loan,
                                   laplace = 3)
    predNB = predict(classifier, newdata = dataSplit2()$testData)
    t <-
      as.data.frame.matrix(table(predNB, dataSplit2()$testData$Personal.Loan))
    list(predNB = predNB,
         NBmodel = classifier,
         table = t)
  })
  
  output$bayes = renderFormattable({
    formattable(naivebayes()$table)
  })
  
  
  #Multiclass model
  
  dataSplit3 <- reactive({
    train3 = input$slider3 / 100
    test3 = 1 - (input$slider3 / 100)
    set.seed(42)
    ind = sample(2,
                 nrow(data),
                 replace = TRUE,
                 prob = c(train3, test3))
    
    
    train.data = data[ind == 1, ]
    test.data = data[ind == 2, ]
    
    list(trainData = train.data, testData = test.data)
  })
  
  rfs = reactive({
    data_rfs = randomForestSRC::rfsrc(Multivar(Education, Family) ~ ., data = dataSplit3()$trainData)
    testPred = predict(data_rfs, newdata = dataSplit3()$testData)
    familyPred = testPred$yvar[, 2]
    educationpred = testPred$yvar[, 1]
    tfamily = as.data.frame.matrix(table(familyPred, dataSplit3()$testData$Family))
    teducation = as.data.frame.matrix(table(educationpred, dataSplit3()$testData$Education))
    list(
      tree = data_rfs,
      predict_family = familyPred,
      predict_education = educationpred,
      tfamily = tfamily,
      teducation = teducation
    )
  })
  
  output$family <- renderFormattable({
    formattable(rfs()$tfamily)
  })
  
  output$education <- renderFormattable({
    formattable(rfs()$teducation)
  })
  
  
  #Deployement
  
  predictData <- reactive({
    dataPredict$Credit[1] <- input$credit
    dataPredict$CD.Account[1] <- input$cdaccount
    dataPredict$Education[1] <- input$education
    dataPredict$Family[1] <- input$family
    dataPredict$Income[1] <- input$income
    dataPredict$CCAvg[1] <- input$ccavg
    dataPredict$Age[1] <- input$age
    dataPredict$Age[1] <- input$age
    list(data = dataPredict)
  })
  
  
  prediction <- reactive({
    if ((input$action) & (input$Model == 'ctree')) {
      value_ctree <- predict(ctreeF()$tree, newdata = predictData()$data)
      list(value = value_ctree)
    } else if ((input$action) & (input$Model == 'bayes')) {
      value_binar <-
        predict(naivebayes()$NBmodel, newdata = predictData()$data)
      list(value = value_binar)
    }
  })
  
  
  output$predicted <- renderText({
    predict <-
      ifelse(prediction()$value == 0, 'No Personal Loan', 'Personal Loan')
    paste('The prediction according to selected criteria is:', predict)
  })
  
})
