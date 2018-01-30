library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(wordcloud)
library("SnowballC")
library("RColorBrewer")
library(dplyr)

setwd("C:/Users/AT003502/Documents/Emma/FB dashboard/facebook data with organic likes/word_test/")

Deskpro<-read.csv("DeskPro_test.csv", header=T)

function(input, output, session) {
  
  getTermMatrix <- memoise(function(services) {
    data <-Deskpro 
    if (input$selection != "All") {
      data <- data[data$Service == input$selection,]
      }
    
    docs <- Corpus(VectorSource(data$Message))
      
    inspect(docs)
    toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
    docs <- tm_map(docs, toSpace, "/")
    docs <- tm_map(docs, toSpace, "@")
    docs <- tm_map(docs, toSpace, "\\|")
    docs <- tm_map(docs, toSpace, ":")
      
      # Convert the text to lower case
    docs <- tm_map(docs, content_transformer(tolower))
      # Remove numbers
    docs <- tm_map(docs, removeNumbers)
      # Remove english common stopwords
    docs <- tm_map(docs, removeWords, stopwords("english"))
      # Remove your own stop word
      # specify your stopwords as a character vector
    my_custom_stopwords<-c("What were you trying to do", 
                             "What were you doing",
                             "need", 
                             "help",
                             "password", 
                             "login",
                             "what do you need help with",
                             "tried",
                             "trying",
                             "log",
                             "tax"
                           ) 
      # Remove punctuations)
    docs <- tm_map(docs, removeWords, my_custom_stopwords)
    docs <- tm_map(docs, removePunctuation)
      # Eliminate extra white spaces
    docs <- tm_map(docs, stripWhitespace)
      # Text stemming
    docs <- tm_map(docs, stemDocument)
      
    dtm <- TermDocumentMatrix(docs)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    d <- data.frame(word = names(v),freq=v)
    head(d,10 )
    str(docs)
    set.seed(1234)
    wordcloud(words = d$word, freq = d$freq, min.freq = 1,
                max.words=50, random.order=FALSE, rot.per=0.35, 
                colors=brewer.pal(8, "RdYlGn"))
      
    sort(rowSums(m),decreasing=TRUE)
    })
  ####start here for the selection
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        #getTermMatrix(input$selection)
        getTermMatrix(input$selection)
        #getTermMatrix(subset(Deskpro$Message,input$selection))
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "RdYlGn"))
  })
}
