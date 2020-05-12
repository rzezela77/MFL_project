########################################################
## 03_serverMozMap.R
#######################################################


output$mozMapUI <- renderUI({
    
    tagList(
        
        argonRow(
            argonColumn(
                width = 12,
                highchartOutput("hc_plot_mozMap", height = "500px")
            )
        )
    )
})


output$hc_plot_mozMap <- renderHighchart({
    
    # visualization
    
    hcmap("countries/mz/mz-all", name = "Unidade Sanitária", 
          data = df_mapdata, 
          value = "value",
          joinBy = c('woe-name', 'province_name'), 
          # dataLabels = list(
          #                   # enabled = TRUE, 
          #                   format = '{point.name}'),
          borderColor = "#FAFAFA", borderWidth = 0.1,
          tooltip = list(valueDecimals = 0, valuePrefix = "", valueSuffix = "")) %>% 
        # hc_add_theme(hc_theme_db() ) %>% 
        hc_add_theme(hc_theme_sandsignika() ) %>% 
        # hc_add_theme(hc_theme_flat() ) %>% 
        hc_chart(zoomType = "xy") %>%
        hc_mapNavigation(enabled = TRUE) %>% 
        hc_colorAxis(stops = color_stops(5)) %>% 
        # hc_colorAxis(dataClasses = color_classes(c(0, 50, 100, 500, 1000, 10000))) %>%
        hc_exporting(enabled = TRUE) %>% 
        hc_tooltip(useHTML = TRUE,
                   headerFormat = '',
                   pointFormat = paste0('<b> {point.name} </b> <br>
                                    Total: <b> {point.value} </b><br>
                                    Hospitais: <b> {point.Hospitais:,0f} </b><br>
                                    Centros de Saude: <b> {point.Centros_Saude:,0f} </b><br>
                                    Postos de Saude: <b> {point.Postos_Saude:,0f} </b><br>') ) %>% 
        hc_title(text = "UNIDADE SANITÁRIA")
    
})