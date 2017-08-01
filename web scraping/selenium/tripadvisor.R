library(dplyr)
library(ggplot2)
tripadvisor = read.csv('reviews.csv',stringsAsFactors = F)
tripadvisor$ranking = rownames(tripadvisor) # adding rankings as a new column
tripadvisor$num_reviews = as.numeric(gsub(',','',gsub(' reviews','',tripadvisor$num_reviews))) # remove the word 'reviews' and comma in the string and convert to numeric
tripadvisor$stars = as.numeric(gsub(' of 5 bubbles','',tripadvisor$stars)) # remove unnecessary part out of column and convert to numeric
tripadvisor %>% filter(cuisine != '') %>% group_by(cuisine) %>% summarize(count=n()) %>% arrange(desc(count)) %>% top_n(10) %>% ggplot(aes(x=reorder(cuisine,-count),y=count)) + geom_col(aes(fill=cuisine))
# finding 10 most represented cuisine types
# Even though French is only the fourth most represented cuisine, it appears quite frequently at the top of the ranking list.
tripadvisor$ranking = as.numeric(tripadvisor$ranking)
ggplot(tripadvisor,aes(num_reviews,ranking))+geom_point() +xlim(0,1000)
ggplot(tripadvisor,aes(price)) + geom_bar(fill='lightblue')+theme_minimal()
tripadvisor %>% filter(ranking <= quantile(ranking,prob=.01)) %>% group_by(cuisine) %>% na.omit() %>% 
  summarize(count=n()) %>% arrange(desc(count)) %>% top_n(10) %>%
  ggplot(aes(x=reorder(cuisine,-count),y=count)) + geom_col(aes(fill=cuisine))
best_res=tripadvisor %>% group_by(cuisine) %>% summarize(ranking=first(ranking)) %>% inner_join(tripadvisor) %>% arrange(ranking) 
best_res = best_res[c(3,1,2,4,5,6)]
# There are 49 types of cuisine represented in this dataset; what's the highest ranked restaurant in each of them?
# and what are some of the esoteric cuisine types for those adventurous eaters?
#tripadvisor %>% group_by(cuisine) %>% count() %>% arrange(n) %>% top_n(1)
# What are the least represented types of cuisines in the set?
total_best = tripadvisor %>% filter(ranking <=25)
least=tripadvisor %>% group_by(cuisine) %>% na.omit() %>% summarize(count=n()) %>% arrange(count) %>% head(10)
least=inner_join(least,tripadvisor)
cor(tripadvisor$num_reviews,tripadvisor$ranking)
tripadvisor$ranking=as.numeric(tripadvisor$ranking)