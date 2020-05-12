######################################################
# getFunctions.R
#####################################################



# 1.0 getting count: Unidade Sanitaria ------------------------------------

getCountUS <-
    function(data = data,
             provincia = 'MAPUTO CIDADE',
             tipoUS = 'Hospitais') {
        
        v_provincia = provincia
        
        if (v_provincia == 'Todas') {
            
            result <-
                data %>%
                summarise(
                    total_hospital = sum(Hospitais),
                    total_centro_saude = sum(Centros_Saude),
                    total_posto_saude = sum(Postos_Saude),
                    grand_total = sum(Total)
                )
        } else{
            result <-
                data %>%
                # filter(PROVINCIA == 'ZAMBÉZIA') %>%
                filter(PROVINCIA == v_provincia) %>%
                # filter(str_detect(provincia, v_provincia)) %>%
                group_by(PROVINCIA) %>%
                summarise(
                    total_hospital = sum(Hospitais),
                    total_centro_saude = sum(Centros_Saude),
                    total_posto_saude = sum(Postos_Saude),
                    grand_total = sum(Total)
                )
        }
        
        
        if (tipoUS == 'Hospitais') {
            v_CountUS <- result$total_hospital
        } else if (tipoUS == 'Centros_Saude') {
            v_CountUS <- result$total_centro_saude
        } else if (tipoUS == 'Postos_Saude') {
            v_CountUS <- result$total_posto_saude
        } else{
            v_CountUS <- result$grand_total
        }
        
        return(v_CountUS)
        
    }

# 2.0 Plotting: Unidade Sanitaria ------------------------------------

hc_plot_US <-
    function(data = data,
             provincia = 'MAPUTO CIDADE') {
        
        v_provincia = as.character(provincia) 

        if (as.character(v_provincia) == 'Todas') {
            # plot All provinces
            plot_data <-
                data %>%
                group_by(PROVINCIA) %>%
                summarise(
                    total_hospital = sum(Hospitais),
                    total_centro_saude = sum(Centros_Saude),
                    total_posto_saude = sum(Postos_Saude),
                    grand_total = sum(Total)
                )


            v_categories <-  plot_data$PROVINCIA


        } else{
            # plot for Provinces
            plot_data <-
                data %>%
                # filter(PROVINCIA == 'NAMPULA') %>%
                # filter(PROVINCIA == v_provincia) %>%
                filter(str_detect(PROVINCIA, v_provincia )) %>% 
                group_by(DISTRITO) %>%
                summarise(
                    total_hospital = sum(Hospitais),
                    total_centro_saude = sum(Centros_Saude),
                    total_posto_saude = sum(Postos_Saude),
                    grand_total = sum(Total)
                )

            v_categories <-  plot_data$DISTRITO
        }

        # chart All
        hc_out <- highchart() %>%
            hc_chart(type = "column") %>%
            # hc_xAxis(categories = plot_data$PROVINCIA) %>%
            hc_xAxis(categories = v_categories) %>%
            hc_add_series(
                data = plot_data$total_hospital,
                name = "Hospitais",
                dataLabels = list(enabled = TRUE)
            ) %>%
            hc_add_series(
                data = plot_data$total_centro_saude,
                name = "Centros de Saude",
                dataLabels = list(enabled = TRUE)
            ) %>%
            hc_add_series(
                data = plot_data$total_posto_saude,
                name = "Postos de Saude",
                dataLabels = list(enabled = TRUE)
            ) %>%
            
            hc_add_series(
                data = plot_data$grand_total,
                name = "Grand Total",
                dataLabels = list(enabled = TRUE)
            ) %>%
            hc_tooltip(crosshairs = TRUE, shared = TRUE) %>%
            hc_exporting(enabled = TRUE)

        hc_out

    }


get_datatable <- function(data = data,
                          provincia = 'MAPUTO CIDADE') {
    
    v_provincia = as.character(provincia) 
    
    if (as.character(v_provincia) == 'Todas') {
        # plot All provinces
        dataset <-
            data %>%
            group_by(PROVINCIA) %>%
            summarise(
                total_hospital = sum(Hospitais),
                total_centro_saude = sum(Centros_Saude),
                total_posto_saude = sum(Postos_Saude),
                grand_total = sum(Total)
            )
        
        
    } else{
        # plot for Provinces
        dataset <-
            data %>%
            # filter(PROVINCIA == 'NAMPULA') %>%
            # filter(PROVINCIA == v_provincia) %>%
            filter(str_detect(PROVINCIA, v_provincia )) %>% 
            group_by(DISTRITO) %>%
            summarise(
                total_hospital = sum(Hospitais),
                total_centro_saude = sum(Centros_Saude),
                total_posto_saude = sum(Postos_Saude),
                grand_total = sum(Total)
            )
    
    }
    
    # datatable
    DT::datatable(
        dataset,
        filter = "top",
        # # class = "stripe cell-border",
        extensions = "Buttons",
        options = list(
            scrollX = TRUE,
            dom = 'Brtip',
            ordering = FALSE,
            buttons = list(list(
                extend = 'collection',
                buttons = c('csv', 'excel', 'pdf'),
                text = 'Download'
            ))
        )
    )
    
}
