fluidPage(
  titlePanel("Exploring Wine Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectizeInput("country",
                     label = "Country",
                     choices = selected_countries),
      selectizeInput("varietal", 'Available Varietals in this Country',
                     choices = unique(wine[wine$country == selected_countries,'variety'])
    ),width=3),
    mainPanel(
    fluidRow(
      tabsetPanel(
        tabPanel('High-Level Observations', 
                 plotOutput('varietal_to_price'),
                 plotOutput('points_to_price')),
        tabPanel('Country-Specific Details',
               column(6, plotOutput("region")),
               column(6, plotOutput("varietal"))),
        tabPanel('Caveats and Takeaways',
               plotOutput('caveats'),
               dataTableOutput('takeaways')
                 )
    )
    )
  )))