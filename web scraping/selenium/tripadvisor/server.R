library(shiny)
library(ggplot2)

function(input, output){
  
  output$top10total <- renderPlot(
   tripadvisor %>% filter(cuisine != '') %>% 
   group_by(cuisine) %>% summarize(count=n()) %>% arrange(desc(count)) %>% 
   top_n(10) %>% ggplot(aes(x=reorder(cuisine,-count),y=count)) + theme(plot.title = element_text(hjust = 0.5))+
   geom_col(aes(fill=cuisine)) + xlab('cuisine') + ggtitle('Top 10 most represented cuisines')
  )
  
  output$top1percent <- renderPlot(
    tripadvisor %>% filter(ranking <= quantile(ranking,prob=.01)) %>% 
    group_by(cuisine) %>% na.omit() %>% summarize(count=n()) %>% arrange(desc(count)) %>% 
    top_n(10) %>% ggplot(aes(x=reorder(cuisine,-count),y=count)) + 
    geom_col(aes(fill=cuisine)) + xlab('cuisine') + ggtitle('Only 5 cuisines remain in the top 1% rankings') +
    theme(plot.title = element_text(hjust = 0.5))
  )

  output$num_review <- renderPlot(
  	ggplot(tripadvisor,aes(num_reviews,ranking))+geom_point(aes(color=price,na.omit=TRUE))+ xlab('number of reviews') + 
  	ggtitle("Does the number of reviews impact a restaurant's ranking?") + xlim(0,2000) +
  	theme(plot.title = element_text(hjust = 0.5))
  )

  total_best = tripadvisor %>% filter(ranking <=25)

  output$totalbest <- renderDataTable(total_best)

  least=tripadvisor %>% group_by(cuisine) %>% na.omit() %>% summarize(count=n()) %>% arrange(count) %>% head(10)
  least=inner_join(least,tripadvisor)

  output$least <- renderDataTable(least)
  
  best_res=tripadvisor %>% group_by(cuisine) %>% summarize(ranking=first(ranking)) %>% inner_join(tripadvisor) %>% arrange(ranking) 
  best_res = best_res[c(3,1,2,4,5,6)]
  
  output$bestres <- renderDataTable(best_res)
}