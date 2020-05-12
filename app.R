

# library(shiny)
# library(argonR)
# library(argonDash)
# 
# library(tidyverse)
# library(shinycssloaders)
# library(shinyWidgets)


# !diagnostics off
source(file = 'global.R', local = TRUE)
source(file = 'getFunctions.R', local = TRUE)

source(file = 'ui/header.R', local = TRUE)
source(file = 'ui/body.R', local = TRUE)
source(file = 'ui/footer.R', local = TRUE)
# source(file = 'ui/dashboardUI.R', local = TRUE)
# source(file = 'ui/sidebar.R')

# source(file = 'CSS.R')

shiny::shinyApp(
    
    ui = argonDashPage(
        title = "Projecto MFL", 
        description = "Projecto MFL", 
        author = "Reinaldo Zezela",
        navbar = NULL, 
        sidebar = NULL, 
        header = header,
        body = body,
        # body = NULL,
        # footer = footer
        footer = NULL
    ),
    
    
    # server ------------------------------------------------------------------
    server = function(input, output) {
        
        source(file = "server/02_serverDashboard.R", local = TRUE)

        # source(file = "server/02_serverWorldMapUI.R", local = TRUE)
        # 
        # source(file = "server/03_serverComparisonUI.R", local = TRUE)
        # 
        # source(file = "server/04_serverForecastUI.R", local = TRUE)
    }
)

