fluidPage(
  titlePanel("NYC Restaurant Ranking by tripadvisor"),
  
  sidebarLayout(
    sidebarPanel(img(src='salt-cellar-restaurant.jpg')
    ),
    mainPanel(
    fluidRow(
      tabsetPanel(
        tabPanel('Not all cuisines are created equal', 
                 plotOutput('top10total'),
                 plotOutput('top1percent')),
        tabPanel('All about those shiny stars',
               plotOutput("num_review"),
               dataTableOutput("totalbest")),
        tabPanel('For you adventurous eaters',
               dataTableOutput('least'),
               dataTableOutput('bestres')
                 )
    )
    )
  )))
