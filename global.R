library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(wordcloud)
library("SnowballC")
library("RColorBrewer")

setwd("C:/Users/AT003502/Documents/Emma/FB dashboard/facebook data with organic likes/word_test/")

Deskpro<-read.csv("DeskPro_test.csv", header=T)
# The list of valid services
service <- list(Deskpro$Service)
# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(services) {
  # Carefluword not to let just any name slip in here; a
  # malicious user could manipulate this value.
  #if (!(service %in% service))
    #stop("Unknown service")
  #if (Deskpro$Service !="All"){
    
  #}
  
  #text <- readLines("DeskPro_test.txt")
  for (i in Deskpro$Service){
    if
    messages<-(Deskpro$Message)
  }
  #in (Deskpro$Service != "All"){
    #Deskpro<-Deskpro[Deskpro$Service==Deskpro$Service,]
  #}
  docs <- Corpus(VectorSource(Deskpro$Message))
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
  

