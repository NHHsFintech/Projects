
## TASK 1 - Gathering the data ##

load("company_index.RData")
setwd("~/NHH/BAN432 Applied Textual Data Analysis for Business and Finance/Assignment 2")

# fetch the URL and store it under a variable
web.url <- "https://www.sec.gov/Archives/edgar/full-index/master.idx"


# download file
edgar.index.raw <- readLines(web.url)

edgar.index <- strsplit(edgar.index.raw[12:length(edgar.index.raw)], 
                        split = "|", 
                        fixed = T)

# First make a matrix
edgar.index <- matrix( unlist(edgar.index), ncol = 5, byrow = T)

# Then make a data frame
edgar.index <- data.frame(edgar.index, stringsAsFactors = F)

# set column names
colnames(edgar.index) <- c("cik", "company.name", "form.type", "date.filed", "url")

# Reduce the data

# Only 10Ks
edgar.index <- subset(edgar.index, form.type == "10-K")

# define file path
edgar.index$file.path <- paste0("K10_", 1:length(edgar.index$form.type), ".txt")

# Loop and download full files
for(i in 1:nrow(edgar.index)){
  download.file(url = paste0("https://www.sec.gov/Archives/", 
                             edgar.index$url[i]), 
                destfile = edgar.index$file.path[i], mode = "wb")
}

# Create new cloumn for variable, "score" early for convenience

edgar.index$score <- NA

## TASK 2 - Clean the data ##

# Start a for loop for cleaning text in all companies

for (i in 1:length(edgar.index$form.type)){
  
  # Read for the company corresponding to each iteration
  print(paste0("Company nr:", i))
  company <- readLines(paste0("K10_",i,".txt"))
  
  # Keep only elements between start text & end text tags
  
  company_begin <- grep("<TEXT>", company, ignore.case = FALSE)
  company_end <- grep("</TEXT>", company, ignore.case = FALSE)
  company_clean <- company[company_begin[1]:company_end[1]]
  
  # Get rid of html tags
  
  company_clean <- gsub("<[^>]*>", "",company_clean)
  company_clean <- gsub("^\\t.*","", company_clean)
  
  # Get rid of html entities
  
  company_clean <- gsub("&.+?;", "", company_clean)
  
  # remove numbers
  
  company_clean <- gsub("[[:digit:]]", "", company_clean)
  
  # get rid of excess whitespaces
  
  company_clean <- stringr::str_replace_all(company_clean, "[\\s]+", " ")
  
  # get rid of empty strings
  
  company_clean <- company_clean[company_clean != ""]
  company_clean <- company_clean[company_clean != " "]
  
  
  # save the clean files and overwrite the earlier K10_i.txt files
  
  writeLines(company_clean, file(paste0("K10_",i,".txt")))
}

## TASK 3 - Clean for KWIC analysis ##

for (i in 1:length(edgar.index$file.path)){
  company_tokenized <- scan(file = edgar.index$file.path[i],
                            what = "character",
                            quote = "")

  
  # piping to clean up unimportant words and starting/ending punctuations
  
  company_tokenized %>%
    tolower() %>% 
    gsub("^[[:punct:]]+|[[:punct:]]+$", "", .) %>% 
    .[!. %in% tm::stopwords()] -> company_tokenized
    
  
  # One vector for word frequencies and one for appending values
  
  environment_words <- c("environment", "green", "sustainable", "renewable", "recycling", "pollusion")
  word_index_count <- c()
  
  # nested for loop for word frequencies for the company
  
  for (j in 1:length(environment_words)){
    count_words <- length(grep(environment_words[j], company_tokenized, ignore.case = TRUE))
    print(paste0(environment_words[j]," count is: ", count_words))
    word_index_count[j] <- count_words
  }
  
  # store the score under a variable
  
  freq_words <- (sum(word_index_count))
  
  # append from freq_words to the corresponding element in the column "score"
  
  edgar.index$score[i] <- freq_words
  
}

## TASK 4 - ESG ##

# Sort the companies in scores in descending order to determine the best scores

company_score <- 
  edgar.index %>% select(2,7) 

company_score[order(-company_score$score),]

# Due to time and memory constraints in loading all html scripts, we tested for n = 2000 readlines
# And our findings were that a set of companies with high score in our test had the value "TRUE" for
# Sustainability in the company_index file.
