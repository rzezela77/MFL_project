body = argonDashBody(
    
    # dashboardUI
    
    # CSS, #CSS.R
    
    argonTabSet(
        id = "tab_Menu",
        card_wrapper = T,
        horizontal = TRUE,
        circle = F,
        size = "sm",
        width = 12,
        iconList = list(
            icon("home"),
            icon("tachometer-alt"), 
            icon("map"), 
            argonIcon("chart-bar-32"),
            # icon("chart-bar"),
            argonIcon("tablet-button"),
            # icon("chart-line"),
            icon("twitter")
        ),
        argonTab(
            tabName = "Pagina Inicial",
            active = T,
            # uiOutput("homeUI") %>% withSpinner()
            argonRow(
                
                # argonColumn(
                #     width = 4,
                #     img(src = 'cdc-k0KRNtqcjfw-unsplash.jpg',width = "100%"),
                #     h6("Source: Photo by CDC on Unsplash",style = 'text-align:center;
                #     font-style: italic;font-weight: bold;')
                # ),
                # argonColumn(
                #     width = 4,
                #     argonAlert(
                #         icon = argonIcon("watch-time"),
                #         status = "primary",
                #         paste("Alert for last updated Data: ", getMaxDate(coronavirus)),
                #         closable = TRUE
                #     )
                # ),
                # argonColumn(
                #     width = 4
                #     # img(src = 'covidGif.gif',width = "100%",height = "80%"),
                #     # h6("Source: Giphy",style = 'text-align:center;font-style: italic;font-weight: bold;')
                # ),
                # argonColumn(
                #     width = 4,
                #     img(src = 'covidGif.gif',width = "100%",height = "80%"),
                #     h6("Source: Giphy",style = 'text-align:center;font-style: italic;font-weight: bold;')
                # )
            )
        ),
        argonTab(
            tabName = "Dashboard",
            active = F,
            # uiOutput("dashboardUI") %>% withSpinner()
            uiOutput("cardUI") %>% withSpinner(),
            tags$br(),
            
           
            argonRow(
                argonColumn(
                    width = 4,
                    pickerInput(
                        inputId = "provinciaInput",
                        label = strong("Seleccione a Provincia:"),
                        choices = c("Todas", unique(mfl_data$PROVINCIA)),
                        selected = "Todas",
                        width = "100%",
                        options = list(`live-search` = TRUE
                                       # `select-all-text` = "Yeah, all !"
                        ),
                        inline = F
                    )
                )

            ),
            # tags$br(),
            
            argonRow(
                argonColumn(
                    width = 12,
                    uiOutput("chartUI") %>% withSpinner()
                )
            )
        ),
        argonTab(
            tabName = "Mapa",
            active = F,
            uiOutput("worldMapUI") %>% withSpinner()
            
        ),
        argonTab(
            tabName = "Comparacao",
            active = F,
            uiOutput("comparisonUI") %>% withSpinner()
            
        ),
        argonTab(
            tabName = "Tabelas",
            active = F,
            argonRow(
                argonColumn(
                    width = 4,
                    pickerInput(
                        inputId = "countryNameInput_v2",
                        label = strong("Select country:"),
                        choices = c("All"),
                        # choices = levels(dataframeTotal$countryName),
                        selected = "Mozambique",
                        width = "100%",
                        options = list(`live-search` = TRUE),
                        inline = F
                    )
                )
            ),
            uiOutput("forecastUI") %>% withSpinner()
        )
    )
)