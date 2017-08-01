library(dplyr)
tripadvisor = read.csv('reviews.csv',stringsAsFactors = F)
tripadvisor$ranking = rownames(tripadvisor) # adding rankings as a new column
tripadvisor$num_reviews = as.numeric(gsub(',','',gsub(' reviews','',tripadvisor$num_reviews))) # remove the word 'reviews' and comma in the string and convert to numeric
tripadvisor$stars = as.numeric(gsub(' of 5 bubbles','',tripadvisor$stars)) # remove unnecessary part out of column and convert to numeric
tripadvisor$ranking = as.numeric(tripadvisor$ranking)