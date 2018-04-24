library(shinydashboard)

shinyUI(dashboardPage(
	dashboardHeader(title = 'Analytics for individual RM on Marc\'s team')),
	dashboardSidebar(
		sidebarUserPanel('Ningxi',image=logo.png)),
	dashboardBody(
		fluidRow(
			box(plotOutput('plot1'))
)))


shinyServer <- function(input, output) { }
