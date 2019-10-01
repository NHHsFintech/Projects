
############################
## WORD FREQUENCY COUNTER ##
############################


## TASK 1 - Load the data ##

load("company_index.RData")
setwd("~/NHH/Applied Textual Data Analysis for Business and Finance/")

# construct url
web.url <- "https://www.sec.gov/Archives/edgar/full-index/master.idx"


# download the master file
edgar.index.raw <- readLines(web.url, n = 2000)

edgar.index <- strsplit(edgar.index.raw[12:length(edgar.index.raw)], 
                        split = "|", 
                        fixed = T)

# make a matrix
edgar.index <- matrix( unlist(edgar.index), ncol = 5, byrow = T)

# make a data.frame
edgar.index <- data.frame(edgar.index, stringsAsFactors = F)

# column names
colnames(edgar.index) <- c("cik", "company.name", "form.type", "date.filed", "url")

# simpler solution (start with list)
# edgar.index <- do.call(rbind, edgar.index)

# Step 1: limit to 10K
edgar.index <- subset(edgar.index, form.type == "10-K")

# Step 1.5: define file path
edgar.index$file.path <- paste0("K10_", 1:length(edgar.index$form.type), ".txt")

# Loop and download the full files
for(i in 1:nrow(edgar.index)){
  download.file(url = paste0("https://www.sec.gov/Archives/", 
                             edgar.index$url[i]), 
                destfile = edgar.index$file.path[i], mode = "wb")
}

## TASK 2 - Clean the data ##

## TASK 3 - Conduct KWIC analysis

## TASK 4 - Provide ESG score

# Start a general for loop for all companies

for (i in 1:length(edgar.index$form.type)){
  
  # Read for the company corresponding to each iteration
  paste0("Company nr:", i)
  company <- readLines(paste0("K10_",1,".txt"))
  
  #Preview
  company[1:200]
  
  #Sort for the area where the text is located
  
  company_begin <- grep("<TEXT>", company, ignore.case = FALSE)
  company_end <- grep("</TEXT>", company, ignore.case = FALSE)
  
  # Shrink to section that actaully contains text
  
  company_clean <- company[company_begin[1]:company_end[1]]
  
  # Get rid of html tags
  
  company_clean <- gsub("<[^>]*>", "",company_clean)
  company_clean <- gsub("^\\t.*","", company_clean)
  
  # Get rid of html entities
  
  company_clean <- gsub("&.+?;", "", company_clean)
  
  # remove numbers
  
  company_clean <- gsub("[[:digit:]]", "", company_clean)
  
  # get rid of whitespaces
  
  company_clean <- stringr::str_replace_all(company_clean, "[\\s]+", " ")
  
  #Preview
  
  company_clean[1:50]
  
  # for loop to save the elements files
  
  for (i in 1:nrow(edgar.index)){
    write.csv(K10.raw, file = edgar.index$file.path[i])
  }
  
  # Clean for KWIC analysis
  
  company_tokenized <- scan(file = company_clean),
                            what = "character",
                            quote = "")
  company_tokenized[1:200]
  company_tokenized <- company_tokenized[-1:12]
  
  
  company_clean <- company_clean[company_clean != ""]
  company_clean <- company_clean[company_clean != " "]
  company_clean[1:50]
  
  company_clean <- tolower(company_clean)
  company_clean[1:50]
  
  company_freq <- table(company_clean)
  company_freq <- sort(company_clean, decreasing = TRUE)
  company_freq[1:80]
  
  
}





  
