# The data was scraped from WineEnthusiast during the week of June 15th, 2017.
# Caveat: the magazine only posts reviews on wines receiving a grade of 80 or more.

# removing unwanted column
wine = wine %>% select(-description) 
# find out which countries are most represented in the dataset
wine %>% group_by(country) %>% summarise(count=n()) %>% arrange(desc(count))

# There are 5 entries missing a country value, but I was able to determine the respective countries for 4 of them,
# and manually add them to the data set (1 from Greece and 3 from Chile).
wine$country = ifelse(wine$designation == 'Askitikos', 'Greece', wine$country)
wine$country = ifelse(wine$designation == 'Piedra Feliz', 'Chile', wine$country)

# Now
       country count
         <chr> <int>observe({

 1          US 62397
 2       Italy 23478
 3      France 21098
 4       Spain  8268
 5       Chile  5819
 6   Argentina  5631
 7    Portugal  5322
 8   Australia  4957
 9 New Zealand  3320
10     Austria  3057

# extracting the top 10 countries from the list:

selected_countries = wine %>% group_by(country) %>% summarise(count=n()) %>% arrange(desc(count)) %>% top_n(10) %>% select(country)
selected_countries = as.character(selected_countries$country)

# creating a country and points data frame containing only the 10 selected countries' data

select_points=wine %>% filter(country %in% selected_countries) %>% select(country, points) %>% arrange(country)

# initial visualization ideas (not all of them were implemented): 
# 1. Does price reflect a wine's quality, indicated by the points given?
ggplot(wine, aes(points,price)) + geom_point() + geom_smooth()
ggplot(wine, aes(points,)) + geom_boxplot()
# 2. Distributions of points by country, in the New and Old Worlds (boxplots)
# 3. Are there any countries that don't produce as much but offer high quality wines?
# 4. Where are the inexpensive but high quality wines?

ggplot(select_points, aes(x=reorder(country,points,median),y=points)) + geom_boxplot(aes(fill=country)) + xlab("Country")
+ ylab("Points") + ggtitle("Distribution of Top 10 Wine Producing Countries") + theme(plot.title = element_text(hjust = 0.5))

wine %>% filter(country %in% selected_countries) %>% group_by(country) %>% summarize(median=median(points)) %>% arrange(desc(median))
 wine %>% filter(!(country %in% selected_countries)) %>% select(country, points) %>% group_by(country) %>% 
 summarise(median=median(points)) %>% arrange(desc(median)) # Gives us England, India, Germany, Slovenia, Canada as top quality producers.

 top=wine %>% group_by(country) %>% summarize(median=median(points)) %>% arrange(desc(median)) %>% top_n(26) # because there's one remaining unidentified country and it showed on the top list
 top=as.character(top$country)

 # finding overlapping countries in the 2 top lists both in terms of production volume (top 10) and quality (top 25)

 both=intersect(top,selected_countries) # Gives us Austria, France, Australia, Italy, Portugal, US, Spain
 others = setdiff(top, selected_countries)
 others = others[others != ''] # Gives us countries that produce high-quality wines

 # finding out the most popular varietals
 # there's a 'red blend' category and one 'Bordeaux-style red blend' category; merging them together:
 wine$variety = ifelse(wine$variety == "Bordeaux-style Red Blend", "Red Blend", wine$variety)
 topwine = wine %>% group_by(variety) %>% summarize(number=n()) %>% arrange(desc(number)) %>% top_n(12)
 topwine=as.character(topwine$variety)

 # selecting top 15% of all wines (the 15% cmae about after a few trial and errors, as 10% yielded nothing in intersection and 20% too many):
top15percent=wine %>% arrange(desc(points)) %>% filter(points > quantile(points, prob = 0.85))
cheapest15percent=wine %>% arrange(price) %>% head(nrow(top15percent))
goodvalue = intersect(top15percent,cheapest15percent)

# Conclusions:
- Overall, wine prices do tend to be positively correlated with perceived quality, at least among these bottles already pre-selected after passing a minimum threshold.
- There are several other countries that produce either












