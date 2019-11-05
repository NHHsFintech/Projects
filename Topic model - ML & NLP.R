
setwd("C:/Users/**INSERT PATH HERE**")
load("firm_dataset.Rdata")

### TOPIC MODELLING ITEM 7. MD&A ###

corpus <- Corpus(VectorSource(section.7.mda))
dtm <- DocumentTermMatrix(corpus,
                          control = list(
                            removePunctuation = T,
                            stopwords = T,
                            stemming = F,
                            removeNumbers = T,
                            wordLengths = c(4, 20),
                            bounds = list(global = c(10,50))
                          ))

# make the matrix sparse where sum of rows are more than 10 frequencies
dtm <- dtm[row_sums(dtm) > 10,]

# estimate the topic model by completing a "gibbs sampling"
topic <- LDA(dtm,
             k = 25,
             method = "Gibbs",
             control = list(
               seed = 1234,
               burnin = 100,
               iter = 300,
               keep = 1,
               save = F,
               verbose = 10
             ))

# inspect the loglikelihood
topic@loglikelihood
plot(topic@loglikelihood, type = "l")

# inspection of controls
topic@k         # the amount of topics in the dtm
topic@alpha     # the dispersion between the topics
topic@control   # summary of the controls
topic@iter      # 400 iterations (to where loglikelihood stagnates)

# document index
topic@documents       # indeces for all 500 documents

# individual terms
topic@terms           # indeces for all 3403 terms that follows the restrictions set in dtm()

# term distribution for each respective topic
beta <- exp(topic@beta)
dim(beta)

# inspect the most common terms of topic 1
head(topic@terms[order(beta[1,], decreasing = T)], 20)    # REIT?
head(topic@terms[order(beta[15,], decreasing = T)], 20)   # coal/mining?
head(topic@terms[order(beta[16,], decreasing = T)], 20)   # automotive?
head(topic@terms[order(beta[20,], decreasing = T)], 20)   # Real estate/supplies/utilities?
head(topic@terms[order(beta[2,], decreasing = T)], 20)    # consultancy
head(topic@terms[order(beta[8,], decreasing = T)], 20)    # medicare?

# Inconsistent with item1 - Business (inspect the LDA estimation, new unsupervised categorization?)

# visualization with term distribution for topic 1
terms.top.40 <- head(topic@terms[order(beta[15,], decreasing = T)], 40)
prob.top.40 <- head(sort(beta[15,], decreasing = T), 40)
wordcloud(words = terms.top.40,
          freq = prob.top.40,
          random.order = F,
          scale = c(4, 1))

# inspect the most common termsn of all topics
apply(beta, 1, function(temp.b){
  head(topic@terms[order(temp.b, decreasing = T)], 5)
})

# Topic distribution for each document
gamma <- topic@gamma
dim(gamma)
gamma[1:25]
sum(gamma[1:25])

# topic loadings for firms 1,15 and 20
barplot(gamma[1,]) 
barplot(gamma[15,])
barplot(gamma[20,])
