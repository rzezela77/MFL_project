#################################################################
## serverDashboard.R
#################################################################



# 1.0 cardUI --------------------------------------------------------------

output$cardUI <- renderUI({

    
    # getting count to ALL provinces
    v_Count_total_geral <-
        getCountUS(data = grupos_unid_sanitaria_tbl,
                   provincia = input$provinciaInput,
                   tipoUS = 'Total')
    
    v_Count_Hospitais <-
        getCountUS(data = grupos_unid_sanitaria_tbl,
                   provincia = input$provinciaInput,
                   tipoUS = 'Hospitais')
    
    v_Count_Centros_Saude <-
        getCountUS(data = grupos_unid_sanitaria_tbl,
                   provincia = input$provinciaInput,
                   tipoUS = 'Centros_Saude')
    
    v_Count_Postos_Saude <-
        getCountUS(data = grupos_unid_sanitaria_tbl,
                   provincia = input$provinciaInput,
                   tipoUS = 'Postos_Saude')
    
    tagList(
        # argonCard(
        # width = 12,
        # src = NULL,
        # background_color = "primary",
        
        argonRow(
            argonInfoCard(
                value = prettyNum(v_Count_total_geral, big.mark = ","),
                title = 'Total Geral',
                icon = argonIcon("ambulance"),
                icon_background = "warning",
                # icon = icon("hospital"),
                background_color = "default"
            ),
            
            argonInfoCard(
                value = prettyNum(v_Count_Hospitais, big.mark = ","),
                title = 'Hospitais',
                # icon = argonIcon("ambulance")
                icon = icon("hospital"),
                icon_background = "info",
                stat = h4(paste0("(", round((v_Count_Hospitais/v_Count_total_geral)*100, 2), '%', ")")) %>% argonTextColor(color = "orange"),
                background_color = "default"
            ),
            
            argonInfoCard(
                value = prettyNum(v_Count_Centros_Saude, big.mark = ","),
                title = 'Centro de Saude',
                # icon = argonIcon("ambulance")
                icon = icon("hospital"),
                icon_background = "success",
                stat = h4(paste0("(", round((v_Count_Centros_Saude/v_Count_total_geral)*100, 2), '%', ")")) %>% argonTextColor(color = "orange"),
                background_color = "default"
            ),
            
            argonInfoCard(
                value = prettyNum(v_Count_Postos_Saude, big.mark = ","),
                title = 'Posto de Saude',
                icon = icon("heartbeat"),
                icon_background = "danger",
                # icon = argonIcon("ambulance")
                # icon = icon("hospital"),
                # icon_background = "warning",
                stat = h4(paste0("(", round((v_Count_Postos_Saude/v_Count_total_geral)*100, 2), '%', ")")) %>% argonTextColor(color = "orange"),
                background_color = "default"
            )
        )
        )
    
})



# 2.0 ChartUI -------------------------------------------------------------


tabsets_tab <- argonTabItem(
    tabName = "tabs",
    
    argonRow(
        
        # # Horizontal Tabset
        # argonColumn(
        #     width = 6,
            # argonH1("Horizontal Tabset", display = 4),
            argonTabSet(
                id = "tab-1",
                card_wrapper = TRUE,
                horizontal = TRUE,
                circle = FALSE,
                size = "sm",
                width = 12,
                # iconList = lapply(X = 1:2, FUN = argonIcon, name = "atom"),
                iconList = list(
                    argonIcon("chart-bar-32"),
                    argonIcon("tablet-button")
                ),
                argonTab(
                    tabName = "Grafico",
                    active = TRUE,
                    # tabText1 <- "Text1"
                    highchartOutput("hc_out_plot", width = "100%", height = "400px")
                ),
                # argonTab(
                #     tabName = "Tab 2",
                #     active = TRUE,
                #     tabText2 <- "Text2"
                # ),
                argonTab(
                    tabName = "Tabelas",
                    active = FALSE,
                    # tabText3 <- "Text3"
                    DT::dataTableOutput("out_dataTable")
                    
                )
            )
        )
    )


output$chartUI <- renderUI({
    
    
    tabsets_tab
    
    
})






# plotting the Cases ------------------------------------------------------

output$hc_out_plot <- renderHighchart({
    
    hc_out <- hc_plot_US(data = grupos_unid_sanitaria_tbl, provincia = input$provinciaInput)

    hc_out
    
})


output$out_dataTable <- DT::renderDataTable({
    
    out_datatable <- get_datatable(data = grupos_unid_sanitaria_tbl, provincia = input$provinciaInput)

    out_datatable
    
    # DT::datatable(
    #     grupos_unid_sanitaria_tbl,
    #     filter = "top",
    #     # # class = "stripe cell-border",
    #     extensions = "Buttons",
    #     options = list(
    #         scrollX = TRUE,
    #         dom = 'Brtip',
    #         ordering = FALSE,
    #         buttons = list(list(
    #             extend = 'collection',
    #             buttons = c('csv', 'excel', 'pdf'),
    #             text = 'Download'
    #         ))
    #     )
    # )
})
