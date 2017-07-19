wine = read.csv('winemag-data_first150k.csv', stringsAsFactors = F)
library(dplyr)
wine = wine %>% select(-description)
wine$country = ifelse(wine$designation == 'Askitikos', 'Greece', wine$country)
wine$country = ifelse(wine$designation == 'Piedra Feliz', 'Chile', wine$country)
selected_countries = wine %>% group_by(country) %>% summarise(count=n()) %>% arrange(desc(count)) %>% top_n(10) %>% select(country)
selected_countries = as.character(selected_countries$country)
select_points=wine %>% filter(country %in% selected_countries) %>% select(country, points) %>% arrange(country)
library(ggplot2)
ggplot(select_points, aes(x=reorder(country,points,median),y=points)) + geom_boxplot(aes(fill=country)) + xlab("Country")+
  ylab("Points") + ggtitle("Distribution of Top 10 Wine Producing Countries")+theme(plot.title = element_text(hjust = 0.5))
wine %>% filter(!(country %in% selected_countries)) %>% select(country, points) %>% group_by(country) %>% summarise(median=median(points)) %>% arrange(desc(median))
wine %>% filter(country %in% selected_countries) %>% group_by(country) %>% summarize(median=median(points)) %>% arrange(desc(median))
wine %>% filter(country == 'Greece') %>% summarize(n())
top=wine %>% group_by(country) %>% summarize(median=median(points)) %>% arrange(desc(median)) %>% top_n(21)
top=as.character(top$country)

outside = setdiff(top, selected_countries)
outside = goodvalue[goodvalue != '']

top15percent=wine %>% arrange(desc(points)) %>% filter(points > quantile(points, prob = 0.85))
cheapest15percent=wine %>% arrange(price) %>% head(nrow(top15percent))
goodvalue = intersect(top15percent,cheapest15percent)
str(goodvalue)
  
nrow(top10percent)
nrow(cheapest10percent)

topwineprice=wine %>% filter(variety %in% topwine) %>% group_by(variety)%>% summarize(median=median(points))
topwineprice

topwine = wine %>% group_by(variety) %>% summarize(number=n()) %>% arrange(desc(number)) %>% top_n(12)
str(topwine)

wine$variety = ifelse(wine$variety == "Bordeaux-style Red Blend", "Red Blend", wine$variety)
wine %>% filter(variety %in% topwine$variety) %>% group_by(variety)%>% summarize(median=median(points)) %>%
  ggplot(aes(variety,median)) + geom_col()
nrow(wine)

wine %>%
  filter(country == input$country) %>% filter(variety %in% topwine$variety) %>%
  ggplot(aes(x = reorder(variety, points), y = points)) +
  geom_boxplot(fill = "red") + xlab('Varietal') + ylab('Point') +
  ggtitle("Wine Quality by Varietal") + scale_x_discrete(labels=abbreviate)