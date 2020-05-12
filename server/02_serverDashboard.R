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
                icon_background = "warning"
                # icon = icon("hospital"),
            ),
            
            argonInfoCard(
                value = prettyNum(v_Count_Hospitais, big.mark = ","),
                title = 'Hospitais',
                # icon = argonIcon("ambulance")
                icon = icon("hospital"),
                icon_background = "info",
                stat = h4(paste0("(", round((v_Count_Hospitais/v_Count_total_geral)*100, 2), '%', ")")) %>% argonTextColor(color = "orange")
            ),
            
            argonInfoCard(
                value = prettyNum(v_Count_Centros_Saude, big.mark = ","),
                title = 'Centro de Saude',
                # icon = argonIcon("ambulance")
                icon = icon("hospital"),
                icon_background = "success",
                stat = h4(paste0("(", round((v_Count_Centros_Saude/v_Count_total_geral)*100, 2), '%', ")")) %>% argonTextColor(color = "orange")
            ),
            
            argonInfoCard(
                value = prettyNum(v_Count_Postos_Saude, big.mark = ","),
                title = 'Posto de Saude',
                icon = icon("heartbeat"),
                icon_background = "danger",
                # icon = argonIcon("ambulance")
                # icon = icon("hospital"),
                # icon_background = "warning",
                stat = h4(paste0("(", round((v_Count_Postos_Saude/v_Count_total_geral)*100, 2), '%', ")")) %>% argonTextColor(color = "orange")
            )
        )
        
    # )
    
    # argonRow(
    #     argonColumn(
    #         width = 4,
    #         pickerInput(
    #             inputId = "provinciaInput",
    #             label = strong("Seleccione a Provincia:"),
    #             choices = c("Todas", levels(mfl_data$PROVINCIA)),
    #             selected = "Todas",
    #             width = "100%",
    #             options = list(`live-search` = TRUE
    #                            # `select-all-text` = "Yeah, all !"
    #             ),
    #             inline = F
    #         )
    #     )
    #     
    # ),
    
    
    )
    
})



# 2.0 ChartUI -------------------------------------------------------------


output$chartUI <- renderUI({
    
    highchartOutput("hc_out_plot", width = "100%", height = "400px")
    
    
})



# plotting the Cases ------------------------------------------------------

output$hc_out_plot <- renderHighchart({
    
    hc_out <- hc_plot_US(data = grupos_unid_sanitaria_tbl, provincia = input$provinciaInput)

    hc_out
    
})

