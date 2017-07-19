library(shiny)
library(ggplot2)

function(input, output, session) {

   observe({
     pickvarietal = unique(wine[wine$country == input$country,'variety'])
     updateSelectInput(session, 'varietal',
                       choices = pickvarietal)
   })

  pickcountry = reactive({
    wine %>%
      filter(country == input$country)})
  
  output$varietal_to_price <- renderPlot(
    wine %>% filter(variety %in% topwine$variety) %>% group_by(variety)%>% summarize(median=median(points)) %>%
    ggplot(aes(reorder(variety,median),median)) + geom_col(aes(fill=variety)) + xlab('Variety') + ylab('Median Point')
  )
  
  output$points_to_price <- renderPlot(
    ggplot(wine, aes(x = points, y = price, color = price)) + 
      geom_point(position = "jitter") + 
      geom_smooth(method = "lm") +
      xlab('Point') + 
      ylab('Price')
  )
  
  output$region <- renderPlot(
    pickcountry() %>% group_by(province) %>% summarise(nprovince=n(),midpoint=median(points)) %>% 
      arrange(desc(nprovince)) %>% top_n(n=8,wt=nprovince) %>%
      ggplot(aes(x = reorder(province,midpoint), y = midpoint, fill=province)) +
      geom_col() + xlab('Province/State') + ylab('Point') +
      ggtitle("Wine Quality of Top 8 Most Represented Regions"))
    
  topwine = wine %>% group_by(variety) %>% summarize(number=n()) %>% arrange(desc(number)) %>% top_n(8)
  
  output$varietal <- renderPlot(
    pickcountry() %>% filter(variety %in% topwine$variety) %>%
      ggplot(aes(x = reorder(variety, points), y = points, fill = variety)) +
      geom_boxplot(show.legend = TRUE) + xlab('Varietal') + ylab('Point') +
      ggtitle("Wine Quality of Top 8 Most Represented Varietals") + scale_x_discrete(labels=abbreviate))

  select_points=wine %>% filter(country %in% selected_countries) %>% select(country, points) %>% arrange(country)
  
  output$caveats <- renderPlot(
    ggplot(select_points, aes(x=reorder(country,points,median),y=points)) + 
      geom_boxplot(aes(fill=country)) + xlab("Country") + ylab("Point") + 
      ggtitle("Distribution of Top 10 Wine Producing Countries") + 
      theme(plot.title = element_text(hjust = 0.5))
  )
  
  top15percent=wine %>% arrange(desc(points)) %>% filter(points > quantile(points, prob = 0.85))
  cheapest15percent=wine %>% arrange(price) %>% head(nrow(top15percent))
  goodvalue = intersect(top15percent,cheapest15percent) 
  
  output$takeaways <- renderDataTable(goodvalue)
}